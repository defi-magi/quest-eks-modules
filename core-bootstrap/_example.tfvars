#---------------------------------------------------------------------------------------------------
# Example variables file, please review each of these variables and update as necessary
#---------------------------------------------------------------------------------------------------
common_tags = {
  application-id = "eks"
  project        = "quest"
  index          = "00"
  team           = "For the Horde"
  environment    = "dev"
  automated-by   = "terraform"
  created-by     = "Alex"
}

# Argo expects the admin password in the secret to be bcrypt hashed. You can create this hash with
# `htpasswd -nbBC 10 "" $ARGO_PWD | tr -d ':\n' | sed 's/$2y/$2a/'`
# The secret is pre-populated and stored in AWS Secrets Manager
argocd_admin_password_secret_name = "eks-quest-00-argocd-admin-password"

argocd_applications = {
  core_bootstrap = {
    name            = "bootstrap"
    path            = "envs/dev"
    repo_url        = "ssh://git@source.shinra.com/core-project/cluster-core-bootstrap.git"
    project         = "default" # don't change unless you know what you're doing
    release_name    = "core-bootstrap"
    target_revision = "HEAD"                           # don't change unless you know what you're doing
    destination     = "https://kubernetes.default.svc" # don't change unless you know what you're doing
    # AWS Secret Manager secret name which contains the SSH key used to access the repo, this secret is pre-populated and should be created per repository
    repo_secret_name = "eks-quest-bootstrap-repo-ssh-key"
    # See all possible ArgoCD values here: https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/values.yaml
    helm_values = {}
  }
}

external_dns_irsa = {
  hosted_zone_arns     = ["arn:aws:route53:::hostedzone/Z095612124BAZ5UCG8F6Y"]
  k8s_service_accounts = ["external-dns:external-dns-irsa"]
}

cert_manager_irsa = {
  hosted_zone_arns     = ["arn:aws:route53:::hostedzone/Z095612124BAZ5UCG8F6Y"]
  k8s_service_accounts = ["cert-manager:cert-manager-irsa"]
}

external_secrets_irsa = {
  deploy_role          = true
  ssm_parameter_arns   = ["*"]
  secrets_manager_arns = ["arn:aws:secretsmanager:us-west-2:811075206237:secret:vault-enterprise-license-z33FWc", "arn:aws:secretsmanager:us-west-2:811075206237:secret:vault-server-tls-certs-*"]
  k8s_service_accounts = ["external-secrets:external-secrets-irsa"]
}
