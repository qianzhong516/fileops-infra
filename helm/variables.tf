variable "region" {
  default = "ap-southeast-2"
}

variable "cluster_name" {
  default = "fileops-cluster"
}

variable "argocd_namespace" {
  default = "argocd"
}

variable "git_ssh_private_key" {
  type      = string
  sensitive = true
}

locals {
  cluster_ca_certificate = data.aws_eks_cluster.cluster.certificate_authority[0].data
  cluster_endpoint       = data.aws_eks_cluster.cluster.endpoint
}
