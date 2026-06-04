# Reference: https://github.com/argoproj/argo-helm#custom-resource-definitions
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "9.5.14"

  values = [
    file("${path.module}/argocd/values.yml")
  ]
}

resource "helm_release" "secrets_store" {
  name       = "secrets-store-csi-driver"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"
  version    = "1.6.0"

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
  version    = "3.1.0"

  values = [
    yamlencode({
      secrets-store-csi-driver = {
        install = false
      }
    })
  ]
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = "prometheus"
  create_namespace = true
  version          = "29.6.0"

  values = [
    yamlencode({
      alertmanager = {
        persistence = {
          storageClass = "gp2"
          // Default 2Gi
          size = "1Gi"
        }
      }
      server = {
        persistentVolume = {
          storageClass = "gp2"
          // Default 8Gi
          size = "4Gi"
        }
      }
    })
  ]

  // To prevent mutation webhook request failure
  depends_on = [helm_release.aws_lbc]
}

resource "helm_release" "grafana_operator" {
  name             = "grafana"
  repository       = "oci://ghcr.io/grafana/helm-charts"
  chart            = "grafana-operator"
  namespace        = "monitoring"
  create_namespace = true
  version          = "5.23.0"

  depends_on = [helm_release.aws_lbc]
}
