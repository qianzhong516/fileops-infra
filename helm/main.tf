# TODO: separate CRD from chart installation to counter the problem of undeleted CRDs after switching namespace. 
# Reference: https://github.com/argoproj/argo-helm#custom-resource-definitions
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = var.argocd_namespace
  create_namespace = true

  # values = [
  #   file("${path.module}/argocd-values.yml")
  # ]
}

# Create application.yaml for ArgoCD
resource "kubernetes_manifest" "argocd_configs" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "argocd-configs"
      namespace = var.argocd_namespace
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "git@github.com:qianzhong516/fileops-app-manifests.git"
        targetRevision = "HEAD"
        path           = "manifests"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "app"
      }

      syncPolicy = {
        automated = {
          prune    = true # Specifies if resources should be pruned during auto-syncing
          selfHeal = true # Specifies if partial app sync should be executed when resources are changed only in target Kubernetes cluster and no git change detected 
        }

        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
}

# TODO: Manage this secret using AWS Secrets Manager + External Secrets Operator
resource "kubernetes_manifest" "git_repo_secret" {
  manifest = {
    apiVersion = "v1"
    kind       = "Secret"
    metadata = {
      name      = "private-repo"
      namespace = var.argocd_namespace
      labels = {
        "argocd.argoproj.io/secret-type" = "repository"
      }
    }
    data = {
      type          = base64encode("git")
      url           = base64encode("git@github.com:qianzhong516/fileops-app-manifests.git")
      sshPrivateKey = base64encode(var.git_ssh_private_key)
    }
  }
}

