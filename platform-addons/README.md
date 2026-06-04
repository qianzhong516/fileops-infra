# platform-addons

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
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.1.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_eks_pod_identity_association.argocd_repo_server](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/eks_pod_identity_association) | resource |
| [aws_eks_pod_identity_association.lbc](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_policy.argocd_repo_server](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lbc](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.argocd_repo_server](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/iam_role) | resource |
| [aws_iam_role.lbc](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.argocd_repo_server_attach](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lbc_attach](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.sops_key_alias](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/kms_alias) | resource |
| [aws_kms_key.sops_key](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/kms_key) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/3.1.1/docs/resources/release) | resource |
| [helm_release.aws_lbc](https://registry.terraform.io/providers/hashicorp/helm/3.1.1/docs/resources/release) | resource |
| [helm_release.grafana_operator](https://registry.terraform.io/providers/hashicorp/helm/3.1.1/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/3.1.1/docs/resources/release) | resource |
| [helm_release.secrets_store](https://registry.terraform.io/providers/hashicorp/helm/3.1.1/docs/resources/release) | resource |
| [helm_release.secrets_store_aws](https://registry.terraform.io/providers/hashicorp/helm/3.1.1/docs/resources/release) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/data-sources/eks_cluster_auth) | data source |
| [terraform_remote_state.state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
