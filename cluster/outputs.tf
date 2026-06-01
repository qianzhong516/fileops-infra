output "kubectl" {
  value = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "tags" {
  value = var.tags
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "region" {
  value = var.region
}

output "private_subnet_ids" {
  value = values(aws_subnet.private_subnet)[*].id
}

output "cluster_node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "cluster_oidc_provider" {
  value = module.eks.oidc_provider
}
