output "kubectl" {
  value = "Run this to connect to your cluster via kubectl: `aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}`"
}
