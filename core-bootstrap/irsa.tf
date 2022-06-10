#---------------------------------------------------------------------------------------------------
# IAM Roles for Service Accounts (IRSA)
# https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/
#---------------------------------------------------------------------------------------------------
# Cert Manager
#---------------------------------------------------------------------------------------------------
module "cert_manager_irsa" {
  count                         = length(var.cert_manager_irsa.hosted_zone_arns) > 0 ? 1 : 0
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                       = "5.1.0"
  role_name                     = local.cert_manager_role_name
  cert_manager_hosted_zone_arns = var.cert_manager_irsa.hosted_zone_arns
  attach_cert_manager_policy    = true

  oidc_providers = {
    main = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = var.cert_manager_irsa.k8s_service_accounts
    }
  }
}

resource "kubernetes_namespace_v1" "cert_manager_irsa" {
  count = length(var.cert_manager_irsa.hosted_zone_arns) > 0 ? 1 : 0
  metadata {
    name = "cert-manager"

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "kubernetes_service_account_v1" "cert_manager_irsa" {
  count = length(var.cert_manager_irsa.hosted_zone_arns) > 0 ? 1 : 0
  metadata {
    name      = "cert-manager-irsa"
    namespace = "cert-manager"
    #annotations = length(var.cert_manager_hosted_zone_arns) > 0 ? { "eks.amazonaws.com/role-arn" : module.cert_manager_irsa.iam_role_arn } : null
    annotations = { "eks.amazonaws.com/role-arn" : one(module.cert_manager_irsa).iam_role_arn }
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "app"                          = "cert-manager"
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/name"       = "cert-manager"
    }
  }

  automount_service_account_token = true
}

#---------------------------------------------------------------------------------------------------
# External DNS
#---------------------------------------------------------------------------------------------------
module "external_dns_irsa" {
  count                         = length(var.external_dns_irsa.hosted_zone_arns) > 0 ? 1 : 0
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                       = "5.1.0"
  role_name                     = local.external_dns_role_name
  external_dns_hosted_zone_arns = var.external_dns_irsa.hosted_zone_arns
  attach_external_dns_policy    = true

  oidc_providers = {
    main = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = var.external_dns_irsa.k8s_service_accounts
    }
  }
}

resource "kubernetes_namespace_v1" "external_dns_irsa" {
  count = length(var.external_dns_irsa.hosted_zone_arns) > 0 ? 1 : 0
  metadata {
    name = "external-dns"

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "kubernetes_service_account_v1" "external_dns_irsa" {
  count = length(var.external_dns_irsa.hosted_zone_arns) > 0 ? 1 : 0
  metadata {
    name        = "external-dns-irsa"
    namespace   = "external-dns"
    annotations = { "eks.amazonaws.com/role-arn" : one(module.external_dns_irsa).iam_role_arn }
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "app"                          = "external-dns"
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/instance"   = "external-dns"
      "app.kubernetes.io/name"       = "external-dns"
    }
  }

  automount_service_account_token = true
}

#---------------------------------------------------------------------------------------------------
# External Secrets Operator
#---------------------------------------------------------------------------------------------------
module "external_secrets_irsa" {
  count                                 = var.external_secrets_irsa.deploy_role ? 1 : 0
  source                                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                               = "5.1.0"
  role_name                             = local.external_secrets_role_name
  external_secrets_ssm_parameter_arns   = try(var.external_secrets_irsa.ssm_parameter_arns, "[" * "]") #TODO, add fix to OS module making the ssm and sm statements dynamic upon input?
  external_secrets_secrets_manager_arns = var.external_secrets_irsa.secrets_manager_arns
  attach_external_secrets_policy        = true

  oidc_providers = {
    main = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = var.external_secrets_irsa.k8s_service_accounts
    }
  }
}

resource "kubernetes_namespace_v1" "external_secrets_irsa" {
  count = var.external_secrets_irsa.deploy_role ? 1 : 0
  metadata {
    name = "external-secrets"

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "kubernetes_service_account_v1" "external_secrets_irsa" {
  count = var.external_secrets_irsa.deploy_role ? 1 : 0
  metadata {
    name        = "external-secrets-irsa"
    namespace   = "external-secrets"
    annotations = { "eks.amazonaws.com/role-arn" : one(module.external_secrets_irsa).iam_role_arn }
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
  automount_service_account_token = true
}
