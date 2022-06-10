# Helm Module

<!-- BEGIN_TF_DOCS -->

# Providers

| Name | Version |
|------|---------|
| helm | >= 2.4.1 |
# Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| helm | >= 2.4.1 |
# Modules

No modules.
# Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| helm_config | Add-on helm chart config, provide repository and version at the minimum. See https://registry.terraform.io/providers/hashicorp/helm/latest/docs. | `any` | n/a |
| set_sensitive_values | Forced set_sensitive values | `any` | `[]` |
| set_values | Forced set values | `any` | `[]` |
| tags | Set of tags or labels to be applied to a resource or a workload | `map(string)` | `null` |
# Outputs

No outputs.
# Resources

| Name | Type |
|------|------|
| [helm_release.addon](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

<!-- END_TF_DOCS -->
