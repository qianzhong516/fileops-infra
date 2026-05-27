locals {
  vpc_id                         = data.terraform_remote_state.state.outputs.vpc_id
  cluster_node_security_group_id = data.terraform_remote_state.state.outputs.cluster_node_security_group_id
  private_subnet_ids             = data.terraform_remote_state.state.outputs.private_subnet_ids
  region                         = data.terraform_remote_state.state.outputs.region
  tags                           = data.terraform_remote_state.state.outputs.tags
}
