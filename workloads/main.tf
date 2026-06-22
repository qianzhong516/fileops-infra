# Create app workloads in ArgoCD
resource "kubernetes_manifest" "app_workloads" {
  manifest = yamldecode(file("${path.module}/manifests/application.yml"))
}
