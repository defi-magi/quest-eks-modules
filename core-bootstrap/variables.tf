variable "common_tags" {
  description = "Tags applied at the AWS provider level that apply to all resources"
  type        = map(string)
}

variable "tags" {
  description = "Specific tags that apply to the workloads"
  type        = map(string)
  default     = null
}

variable "eks_oidc_provider_arn" {
  type        = string
  default     = null
  description = "The OIDC provider ARN that enables Role to Service Account connectivity"
}

variable "argocd_admin_password_secret_name" {
  type        = string
  default     = null
  description = "Name for a secret stored in AWS Secrets Manager that contains the admin password for ArgoCD."
}

variable "argocd_helm_config" {
  type        = any
  default     = {}
  description = "Argo CD Kubernetes add-on config"
}

variable "argocd_applications" {
  type        = any
  default     = {}
  description = "Argo CD Applications config to bootstrap the cluster"
}

variable "external_dns_irsa" {
  type        = map(any)
  default     = null
  description = "The hosted zone ARNs that external DNS is allowed to manage in order to create DNS records"
}

variable "cert_manager_irsa" {
  type        = map(any)
  default     = null
  description = "The hosted zone ARNs that cert manager is allowed to manage in order to create TXT records for domain validation"
}

variable "external_secrets_irsa" {
  type        = any
  default     = null
  description = "Secret mgr or ssm ARNs that external secrets operator is allowed to read in order to create secrets in k8s"
}
