# TODO: separate CRD from chart installation to counter the problem of undeleted CRDs after a namespace switch. 
# Reference: https://github.com/argoproj/argo-helm#custom-resource-definitions
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  # values = [
  #   file("${path.module}/argocd-values.yml")
  # ]
}
