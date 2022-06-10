variable "common_tags" {
  description = "Tags applied at the AWS provider level that apply to all resources"
  type        = map(string)
}

variable "tags" {
  description = "Specific tags that apply to the workloads"
  type        = map(string)
  default     = null
}

variable "vpc_id" {
  description = "vpc ID"
  type        = string
}

variable "k8s_version" {
  description = "kubernetes cluster version"
  type        = string
}

variable "aws_auth_config" {
  type        = any
  default     = null
  description = "Configure AWS SSO based authentication for EKS clusters"
}

variable "subnet_ids" {
  description = "list of private subnets"
  type        = list(string)
}

variable "control_plane_api_allow_list_cidrs" {
  description = "The CIDR blocks that are permitted to access the control plane API"
  type        = list(string)
}

variable "cluster_log_types" {
  description = "A list of desired control plane logging to enable"
  type        = list(string)
}

variable "instance_types" {
  description = "A list of instance types for the Managed Node Group"
  type        = list(string)
}

variable "managed_node_groups" {
  type        = map(any)
  description = "The node groups that will be provisioned for the EKS cluster"
}
