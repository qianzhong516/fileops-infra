# data

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.15.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.44.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.44.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_rds"></a> [rds](#module\_rds) | terraform-aws-modules/rds/aws | 7.2.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_iam_policy.backend_db_secret](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.backend_db_secret](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.backend_db_secret](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route53_record.db_dev](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/route53_record) | resource |
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.fileops](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/data-sources/route53_zone) | data source |
| [aws_secretsmanager_secret.db_secret](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/data-sources/secretsmanager_secret) | data source |
| [terraform_remote_state.state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_db_host"></a> [db\_host](#output\_db\_host) | n/a |
| <a name="output_rds_secret_name"></a> [rds\_secret\_name](#output\_rds\_secret\_name) | n/a |
<!-- END_TF_DOCS -->
