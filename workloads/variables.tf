locals {
  region                 = data.terraform_remote_state.state.outputs.region
  cluster_name           = data.terraform_remote_state.state.outputs.cluster_name
  cluster_ca_certificate = data.aws_eks_cluster.cluster.certificate_authority[0].data
  cluster_endpoint       = data.aws_eks_cluster.cluster.endpoint
  cluster_token          = data.aws_eks_cluster_auth.cluster.token
}

variable "git_ssh_private_key" {
  type      = string
  sensitive = true
}
