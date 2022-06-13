# Core Bootstrap
- [Core Bootstrap](#core-bootstrap)
  - [Introduction](#introduction)
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

This module bootstraps the EKS cluster with required ServiceAccounts and ArgoCD. When a cluster is bootstrapped it then looks to a source of truth Git repository to bring the cluster to the defined state.

## Introduction
Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes. Application definitions, configurations, and environments should be declarative and version controlled. Application deployment and lifecycle management should be automated, auditable, and easy to understand.

## What's Created
Below are the primary components created by this module. This is meant to provide a high-level overview and not to function as an extensive inventory of all resources provisioned.

- ArgoCD bootstrap application(s)
  - You can have multiple apps bootstrapped but ideally it's best to provision everything through the [app-of-apps](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/) pattern
- [IRSA](https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/) roles
  - Cert Manager
  - External DNS
  - External Secrets Operator

## Considerations
The `_example.tfvars` is living documentation of how the variables should be defined. Please read the variables file carefully and make the appropriate changes before deploying your cluster. There are secrets that need to be pre-populated in AWS Secrets Manager for bootstrap provisioning to work, these secrets are:

- ArgoCD admin password
  -  Argo expects the admin password in the secret to be bcrypt hashed
  - `htpasswd -nbBC 10 "" $ARGO_PWD | tr -d ':\n' | sed 's/$2y/$2a/'`
- Private SSH key for the repository that you are provisioning
  - This should **NOT** be the key of your personal profile (plz don't do this)

The secrets are provided by the following variables:
- *var.argocd_applications.core_bootstrap.repo_secret_name*
- *var.argocd_admin_password_secret_name*

Another important consideration is the providing the 'source of truth' repository itself, this is where the cluster looks to in order to sync the desired configuration.
- var.argocd_applications.core_boostrap.repo_url
  - Put the SSH GitHub repo clone URL
- The target revision can be set with the `var.argocd_applications.core_bootstrap.target_revision` variable
  - The easiest way to think of this in this particular context is a branch `master`, `feature/testing-stuff`, `main`, `dev`, etc.
  - Leaving this at `HEAD` means that you're targeting the latest commit at origin

## How to Use
```go
module "argocd_bootstrap" {
  source                            = "git::git@github.com:defi-magi/quest-eks-modules.git//core-bootstrap?ref=v1.0.0"
  common_tags                       = var.common_tags
  tags                              = var.tags
  eks_oidc_provider_arn             = data.terraform_remote_state.cluster_core.outputs.eks_cluster_full_outputs.oidc_provider_arn
  argocd_admin_password_secret_name = var.argocd_admin_password_secret_name
  argocd_applications               = var.argocd_applications
  external_dns_irsa                 = var.external_dns_irsa
  cert_manager_irsa                 = var.cert_manager_irsa
  external_secrets_irsa             = var.external_secrets_irsa
}
```

After provisioning, you will want to access the ArgoCD UI in order to understand what is happening with the sync operations from the defined repository. To access the ArgoCD front-end from within the cluster (without having ingress routing configured) port-forwarding command needs to be run:

```shell
kubectl port-forward service/argo-cd-argocd-server 28015:80 -n argocd
```

You can then browse to the UI on: https://127.0.0.1:28015/

## Generated Documentation
<!-- BEGIN_TF_DOCS -->

# Providers

| Name | Version |
|------|---------|
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
| argocd | ../argocd | n/a |
| cert_manager_irsa | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.1.0 |
| external_dns_irsa | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.1.0 |
| external_secrets_irsa | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.1.0 |
# Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| argocd_admin_password_secret_name | Name for a secret stored in AWS Secrets Manager that contains the admin password for ArgoCD. | `string` | `null` |
| argocd_applications | Argo CD Applications config to bootstrap the cluster | `any` | `{}` |
| argocd_helm_config | Argo CD Kubernetes add-on config | `any` | `{}` |
| cert_manager_irsa | The hosted zone ARNs that cert manager is allowed to manage in order to create TXT records for domain validation | `map(any)` | `null` |
| common_tags | Tags applied at the AWS provider level that apply to all resources | `map(string)` | n/a |
| eks_oidc_provider_arn | The OIDC provider ARN that enables Role to Service Account connectivity | `string` | `null` |
| external_dns_irsa | The hosted zone ARNs that external DNS is allowed to manage in order to create DNS records | `map(any)` | `null` |
| external_secrets_irsa | Secret mgr or ssm ARNs that external secrets operator is allowed to read in order to create secrets in k8s | `any` | `null` |
| tags | Specific tags that apply to the workloads | `map(string)` | `null` |
# Outputs

| Name | Description |
|------|-------------|
| iam_roles_for_service_accounts_arns | The role ARNs that will be bound to K8s service accounts in order to grant least privilaged access to AWS actions |
# Resources

| Name | Type |
|------|------|
| [kubernetes_namespace_v1.cert_manager_irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.external_dns_irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.external_secrets_irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/namespace_v1) | resource |
| [kubernetes_service_account_v1.cert_manager_irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/service_account_v1) | resource |
| [kubernetes_service_account_v1.external_dns_irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/service_account_v1) | resource |
| [kubernetes_service_account_v1.external_secrets_irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/service_account_v1) | resource |

<!-- END_TF_DOCS -->