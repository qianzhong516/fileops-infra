locals {
  region                 = data.terraform_remote_state.cluster.outputs.region
  cluster_name           = data.terraform_remote_state.cluster.outputs.cluster_name
  cluster_node_role_arn  = data.terraform_remote_state.cluster.outputs.eks_managed_node_groups.fileops-node-group.iam_role_arn
  cluster_ca_certificate = data.aws_eks_cluster.cluster.certificate_authority[0].data
  cluster_endpoint       = data.aws_eks_cluster.cluster.endpoint
  cluster_token          = data.aws_eks_cluster_auth.cluster.token
  account_id             = data.aws_caller_identity.current.id
  vpc_id                 = data.terraform_remote_state.cluster.outputs.vpc_id
  tags                   = data.terraform_remote_state.cluster.outputs.tags
}
