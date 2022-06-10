#---------------------------------------------------------------------------------------------------
# ArgoCD used for GitOps based cluster bootstrapping
# https://argo-cd.readthedocs.io/en/stable/
#---------------------------------------------------------------------------------------------------
module "argocd" {
  source                     = "../argocd"
  helm_config                = var.argocd_helm_config
  applications               = var.argocd_applications
  admin_password_secret_name = var.argocd_admin_password_secret_name
  tags                       = var.common_tags
}