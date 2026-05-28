locals {
  vpc_id                         = data.terraform_remote_state.state.outputs.vpc_id
  account_id                     = data.aws_caller_identity.current.account_id
  cluster_oidc_provider          = data.terraform_remote_state.state.outputs.cluster_oidc_provider
  cluster_node_security_group_id = data.terraform_remote_state.state.outputs.cluster_node_security_group_id
  private_subnet_ids             = data.terraform_remote_state.state.outputs.private_subnet_ids
  region                         = data.terraform_remote_state.state.outputs.region
  tags                           = data.terraform_remote_state.state.outputs.tags
}
