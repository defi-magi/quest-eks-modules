# ArgoCD
Application definitions, configurations, and environments should be declarative and version controlled. Application deployment and lifecycle management should be automated, auditable, and easy to understand.

https://argo-cd.readthedocs.io/en/stable/

![GitOps](../static/gitops-kubernetes-argocd.png)

<!-- BEGIN_TF_DOCS -->

# Providers

| Name | Version |
|------|---------|
| aws | >= 3.72 |
| helm | >= 2.4.1 |
| kubernetes | >= 2.10 |
# Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 3.72 |
| helm | >= 2.4.1 |
| kubernetes | >= 2.10 |
# Modules

| Name | Source | Version |
|------|--------|---------|
| helm | ../helm | n/a |
# Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| admin_password_secret_name | Name for a secret stored in AWS Secrets Manager that contains the admin password for ArgoCD. | `string` | `""` |
| applications | ArgoCD Application config used to bootstrap a cluster. | `any` | `{}` |
| helm_config | ArgoCD Helm Chart Config values | `any` | `{}` |
| tags | Set of tags or labels to be applied to a resource or a workload | `map(string)` | `null` |
# Outputs

No outputs.
# Resources

| Name | Type |
|------|------|
| [helm_release.argocd_application](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret.argocd_gitops](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [aws_secretsmanager_secret.admin_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret.ssh_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.admin_password_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.ssh_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

<!-- END_TF_DOCS -->
