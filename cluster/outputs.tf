output "kubectl" {
  value = "Run this to connect to your cluster via kubectl: `aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}`"
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "tags" {
  value = local.tags
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "region" {
  value = var.region
}

output "workflow_test" {
  value = "cluster"
}
