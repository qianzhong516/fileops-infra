# TODO: separate CRD from chart installation to counter the problem of undeleted CRDs after switching namespace. 
# Reference: https://github.com/argoproj/argo-helm#custom-resource-definitions
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = var.argocd_namespace
  create_namespace = true

  values = [
    file("${path.module}/argocd/values.yml")
  ]
}
