<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.15.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.44.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 3.1.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 3.1.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.44.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 3.1.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [kubernetes_manifest.app_workloads](https://registry.terraform.io/providers/hashicorp/kubernetes/3.1.0/docs/resources/manifest) | resource |
| [kubernetes_manifest.git_repo_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/3.1.0/docs/resources/manifest) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/data-sources/eks_cluster_auth) | data source |
| [terraform_remote_state.state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_git_ssh_private_key"></a> [git\_ssh\_private\_key](#input\_git\_ssh\_private\_key) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
