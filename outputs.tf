output "kubectl" {
  value = <<-EOT
    aws eks update-kubeconfig \
      --region ${var.region} \
      --name ${module.eks.cluster_name}
  EOT
}
