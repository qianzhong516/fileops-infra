locals {
  region                 = data.terraform_remote_state.state.outputs.region
  cluster_name           = data.terraform_remote_state.state.outputs.cluster_name
  cluster_ca_certificate = data.aws_eks_cluster.cluster.certificate_authority[0].data
  cluster_endpoint       = data.aws_eks_cluster.cluster.endpoint
  cluster_token          = data.aws_eks_cluster_auth.cluster.token
  account_id             = data.aws_caller_identity.current.id
  vpc_id                 = data.terraform_remote_state.state.outputs.vpc_id
  tags                   = data.terraform_remote_state.state.outputs.tags
}
