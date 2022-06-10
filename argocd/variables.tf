variable "tags" {
  description = "Set of tags or labels to be applied to a resource or a workload"
  type        = map(string)
  default     = null
}

variable "helm_config" {
  type        = any
  default     = {}
  description = "ArgoCD Helm Chart Config values"
}

variable "applications" {
  type        = any
  default     = {}
  description = "ArgoCD Application config used to bootstrap a cluster."
}

variable "admin_password_secret_name" {
  type        = string
  default     = ""
  description = "Name for a secret stored in AWS Secrets Manager that contains the admin password for ArgoCD."
}
