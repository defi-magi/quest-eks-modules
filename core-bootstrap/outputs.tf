output "iam_roles_for_service_accounts_arns" {
  description = "The role ARNs that will be bound to K8s service accounts in order to grant least privilaged access to AWS actions"
  value = {
    cert_manager     = length(module.cert_manager_irsa) > 0 ? one(module.cert_manager_irsa).iam_role_arn : null
    external_dns     = length(module.external_dns_irsa) > 0 ? one(module.external_dns_irsa).iam_role_arn : null
    external_secrets = length(module.external_secrets_irsa) > 0 ? one(module.external_secrets_irsa).iam_role_arn : null
  }
}
