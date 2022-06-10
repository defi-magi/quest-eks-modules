module "helm" {
  source               = "../helm"
  helm_config          = local.helm_config
  set_sensitive_values = local.set_sensitive
  #depends_on           = [kubernetes_namespace_v1.this]
}

# ---------------------------------------------------------------------------------------------------------------------
# ArgoCD App of Apps Bootstrapping
# ---------------------------------------------------------------------------------------------------------------------
resource "helm_release" "argocd_application" {
  for_each = var.applications

  name      = each.value.release_name
  chart     = "${path.module}/argocd-application"
  version   = "1.0.0"
  namespace = local.helm_config["namespace"]

  set {
    name  = "name"
    value = each.value.name
  }

  set {
    name  = "project"
    value = each.value.project
  }

  # Source Config.
  set {
    name  = "source.repoUrl"
    value = each.value.repo_url
  }

  set {
    name  = "source.targetRevision"
    value = each.value.target_revision
  }

  set {
    name  = "source.path"
    value = each.value.path
  }

  set {
    name  = "source.helm.releaseName"
    value = each.value.release_name
  }

  # Destination Config.
  set {
    name  = "destination.server"
    value = each.value.destination
  }

  depends_on = [module.helm]
}

# ---------------------------------------------------------------------------------------------------------------------
# Private Repo Access
# ---------------------------------------------------------------------------------------------------------------------
resource "kubernetes_secret" "argocd_gitops" {
  for_each = { for k, v in var.applications : k => v if try(v.repo_secret_name, null) != null }

  metadata {
    name      = "${each.value.name}-repo-secret"
    namespace = local.helm_config["namespace"]
    labels    = { "argocd.argoproj.io/secret-type" : "repository" }
  }

  data = {
    type          = "git"
    url           = each.value.repo_url
    sshPrivateKey = data.aws_secretsmanager_secret_version.ssh_key[each.key].secret_string
  }

  depends_on = [module.helm]
}
