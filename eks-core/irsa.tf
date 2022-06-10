#---------------------------------------------------------------------------------------------------
# IAM Roles for Service Accounts (IRSA)
# https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/
#---------------------------------------------------------------------------------------------------
# VPC CNI
#---------------------------------------------------------------------------------------------------
module "vpc_cni_irsa" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version               = "5.1.0"
  role_name             = local.vpc_cni_role_name
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}
