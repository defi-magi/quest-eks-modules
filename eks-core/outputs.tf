output "eks_cluster_id" {
  description = "The name of the cluster"
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_full_outputs" {
  description = "The endpoint of the cluster"
  value       = module.eks
}

output "iam_roles_for_service_accounts_arns" {
  description = "The role ARNs that will be bound to K8s service accounts in order to grant least privilaged access to AWS actions"
  value = {
    vpc_cni = module.vpc_cni_irsa.iam_role_arn
  }
}
