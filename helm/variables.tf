variable "region" {
  default = "ap-southeast-2"
}

variable "cluster_name" {
  default = "fileops-cluster"
}

locals {
  cluster_ca_certificate = data.aws_eks_cluster.cluster.certificate_authority[0].data
}
