locals {
  cert_manager_role_name     = format("%s-%s-%s-%s-%s", var.common_tags.application-id, var.common_tags.project, "cluster", "cert-mgr-role", var.common_tags.index)
  external_dns_role_name     = format("%s-%s-%s-%s-%s", var.common_tags.application-id, var.common_tags.project, "cluster", "external-dns-role", var.common_tags.index)
  external_secrets_role_name = format("%s-%s-%s-%s-%s", var.common_tags.application-id, var.common_tags.project, "cluster", "ext-secrets-role", var.common_tags.index)
}
