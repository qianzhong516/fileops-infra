# cluster

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

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 21.20.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/internet_gateway) | resource |
| [aws_kms_alias.eks_encryption_key_alias](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/kms_alias) | resource |
| [aws_kms_grant.eks_cluster_role_grant](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/kms_grant) | resource |
| [aws_kms_key.eks_encryption_key](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/kms_key) | resource |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/nat_gateway) | resource |
| [aws_route_table.private_route_table](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/route_table) | resource |
| [aws_route_table.public_route_table](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/route_table_association) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/6.44.0/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | n/a | `map(string)` | <pre>{<br/>  "private-a": "ap-southeast-2a",<br/>  "private-b": "ap-southeast-2b",<br/>  "private-c": "ap-southeast-2c",<br/>  "public-a": "ap-southeast-2a",<br/>  "public-b": "ap-southeast-2b",<br/>  "public-c": "ap-southeast-2c"<br/>}</pre> | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | n/a | `map(string)` | <pre>{<br/>  "private-a": "10.0.11.0/24",<br/>  "private-b": "10.0.12.0/24",<br/>  "private-c": "10.0.13.0/24"<br/>}</pre> | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | n/a | `map(string)` | <pre>{<br/>  "public-a": "10.0.1.0/24",<br/>  "public-b": "10.0.2.0/24",<br/>  "public-c": "10.0.3.0/24"<br/>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"ap-southeast-2"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br/>  "Environment": "dev",<br/>  "Project": "FileOps"<br/>}</pre> | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_kubectl"></a> [kubectl](#output\_kubectl) | n/a |
| <a name="output_region"></a> [region](#output\_region) | n/a |
| <a name="output_tags"></a> [tags](#output\_tags) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
| <a name="output_workflow_test"></a> [workflow\_test](#output\_workflow\_test) | n/a |
<!-- END_TF_DOCS -->
