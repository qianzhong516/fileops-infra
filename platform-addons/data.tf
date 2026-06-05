data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

# TODO: Remote state sharing exposes sensitive info to the consumer (if any). Publish non-sensitive configurations to a 3rd party storage like S3 for security.
data "terraform_remote_state" "cluster" {
  backend = "remote"

  config = {
    organization = "janice-zhong"
    workspaces = {
      name = "janice-zhong-fileops-cluster"
    }
  }
}
