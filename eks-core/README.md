# AWS EKS Core
- [AWS EKS Core](#aws-eks-core)
  - [What's Created](#whats-created)
  - [Considerations](#considerations)
  - [How to Use](#how-to-use)
  - [Generated Documentation](#generated-documentation)
- [Providers](#providers)
- [Requirements](#requirements)
- [Modules](#modules)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Resources](#resources)

This module is used to create a barebones EKS cluster. The module supports provisioning of multiple managed node groups with standardized naming conventions stitched together using tag inputs. Ideally this module should be coupled with the [core-bootstrap](../core-bootstrap/) module for provisioning base set of workloads/components on the cluster for it to be considered operational.

This module pulls in the following upstream module:
- https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/18.23.0
  - https://github.com/terraform-aws-modules/terraform-aws-eks

## What's Created
Below are the primary components created by this module. This is meant to provide a high-level overview and not to function as an extensive inventory of all resources provisioned.

- AWS managed K8s control plane (EKS)
- Managed node group(s)
- IRSA role for VPC CNI 
  - [IAM Roles for Service Accounts (IRSA)](https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/)
- KMS key used to encrypt cluster secrets at rest
- Default node security group

## Considerations
The `_example.tfvars` is living documentation of how the variables should be defined. Please read the variables file carefully and make the appropriate changes before deploying your cluster. Another important consideration is that the cluster and node-group names are stitched together using the provided tags, let's take this example:

**Tags**
```go
common_tags = {
  application-id                    = "eks"
  project                           = "quest"
  index                             = "00"
  team                              = "For the Horde"
  environment                       = "dev"
  automated-by                      = "terraform"
  created-by                        = "Alex"
}
```

**Conventions**
- Cluster: `format("%s-%s-%s-%s-%s", var.common_tags.application-id, var.common_tags.project, "cluster", var.common_tags.Environment, var.common_tags.index)`
- Node Group: `format("%s-%s-%s-%s-%s-%s", var.common_tags.application-id, var.common_tags.project, "cluster", "node-group", v.name, v.index)`

**Resulting Names**
- Cluster: `eks-quest-cluster-dev-00`
- Node Group: `eks-quest-cluster-node-group-gpc-00`

## How to Use
```go
module "eks_00" {
  source                             = "git::git@github.com:defi-magi/quest-eks-modules.git//eks-core?ref=v1.0.0"
  common_tags                        = var.common_tags
  tags                               = var.tags
  k8s_version                        = var.k8s_version
  vpc_id                             = var.vpc_id
  subnet_ids                         = var.subnet_ids
  control_plane_api_allow_list_cidrs = var.control_plane_api_allow_list_cidrs
  instance_types                     = var.instance_types
  cluster_log_types                  = var.cluster_log_types
  aws_auth_config                    = var.aws_auth_config
  managed_node_groups                = var.managed_node_groups
}
```

## Generated Documentation
<!-- BEGIN_TF_DOCS -->

# Providers

| Name | Version |
|------|---------|
| aws | = 4.15.1 |
| kubernetes | = 2.11.0 |
# Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.2.0 |
| aws | = 4.15.1 |
| helm | = 2.5.1 |
| kubernetes | = 2.11.0 |
| local | = 2.2.2 |
| random | = 3.2.0 |
| tls | = 3.4.0 |
# Modules

| Name | Source | Version |
|------|--------|---------|
| argocd | ../modules/argocd | n/a |
| cert_manager_irsa | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.1.0 |
| eks | terraform-aws-modules/eks/aws | 18.23.0 |
| external_dns_irsa | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.1.0 |
| external_secrets_irsa | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.1.0 |
| vpc_cni_irsa | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.0.0 |
# Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| argocd_admin_password_secret_name | Name for a secret stored in AWS Secrets Manager that contains the admin password for ArgoCD. | `string` | `""` |
| argocd_applications | Argo CD Applications config to bootstrap the cluster | `any` | `{}` |
| argocd_helm_config | Argo CD Kubernetes add-on config | `any` | `{}` |
| aws_auth_config | Configure AWS based authentication for EKS clusters | `map(any)` | `null` |
| cert_manager_irsa | The hosted zone ARNs that cert manager is allowed to manage in order to create TXT records for domain validation | `map(any)` | `null` |
| cluster_log_types | A list of desired control plane logging to enable | `list(string)` | n/a |
| common_tags | tags from origin | `map(string)` | n/a |
| control_plane_api_allow_list_cidrs | The CIDR blocks that are permitted to access the control plane API | `list(string)` | n/a |
| external_dns_irsa | The hosted zone ARNs that external DNS is allowed to manage in order to create DNS records | `map(any)` | `null` |
| external_secrets_irsa | Secret mgr or ssm ARNs that external secrets operator is allowed to read in order to create secrets in k8s | `any` | `null` |
| instance_types | A list of instance types for the Managed Node Group | `list(string)` | n/a |
| k8s_version | kubernetes cluster version | `string` | n/a |
| managed_node_groups | The node groups that will be provisioned for the EKS cluster | `map(any)` | n/a |
| subnet_ids | list of private subnets | `list(string)` | n/a |
| tags | tags from origin | `map(string)` | `null` |
| vpc_id | vpc ID | `string` | n/a |
# Outputs

| Name | Description |
|------|-------------|
| eks_cluster_id | The name of the cluster |
| iam_roles_for_service_accounts_arns | The role ARNs that will be bound to K8s service accounts in order to grant least privilaged access to AWS actions |
# Resources

| Name | Type |
|------|------|
| [aws_kms_key.eks](https://registry.terraform.io/providers/hashicorp/aws/4.15.1/docs/resources/kms_key) | resource |
| [aws_security_group.default_node_security_group](https://registry.terraform.io/providers/hashicorp/aws/4.15.1/docs/resources/security_group) | resource |
| [kubernetes_namespace_v1.cert_manager_irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.external_dns_irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.external_secrets_irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/namespace_v1) | resource |
| [kubernetes_service_account_v1.cert_manager_irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/service_account_v1) | resource |
| [kubernetes_service_account_v1.external_dns_irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/service_account_v1) | resource |
| [kubernetes_service_account_v1.external_secrets_irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/service_account_v1) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.15.1/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/4.15.1/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/4.15.1/docs/data-sources/eks_cluster_auth) | data source |

<!-- END_TF_DOCS -->