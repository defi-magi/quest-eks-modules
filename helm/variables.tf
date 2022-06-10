variable "tags" {
  description = "Set of tags or labels to be applied to a resource or a workload"
  type        = map(string)
  default     = null
}

variable "helm_config" {
  type        = any
  description = <<EOT
Add-on helm chart config, provide repository and version at the minimum.
See https://registry.terraform.io/providers/hashicorp/helm/latest/docs.
EOT
}

variable "set_values" {
  type        = any
  description = "Forced set values"
  default     = []
}

variable "set_sensitive_values" {
  type        = any
  description = "Forced set_sensitive values"
  default     = []
}
