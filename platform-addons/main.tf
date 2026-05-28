# Reference: https://github.com/argoproj/argo-helm#custom-resource-definitions
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  values = [
    file("${path.module}/argocd/values.yml")
  ]
}

resource "helm_release" "secrets_store" {
  name       = "secrets-store-csi-driver"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"

  values = [
    yamlencode({
      syncSecret = {
        enabled = true
      }
      tokenRequests = [
        { audience = "sts.amazonaws.com" },
        { audience = "pods.eks.amazonaws.com" }
      ]
    })
  ]
}

resource "helm_release" "secrets_store_aws" {
  name       = "secrets-store-csi-driver-provider-aws"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = "kube-system"

  values = [
    yamlencode({
      secrets-store-csi-driver = {
        install = false
      }
    })
  ]
}
