# TODO: separate CRD from chart installation to counter the problem of undeleted CRDs after switching namespace. 
# Reference: https://github.com/argoproj/argo-helm#custom-resource-definitions
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = var.argocd_namespace
  create_namespace = true

  values = [
    file("${path.module}/argocd-values.yml")
  ]
}

# Create app workloads in ArgoCD
resource "kubernetes_manifest" "app_workloads" {
  manifest = yamldecode(templatefile("${path.module}/application.yml", {
    argocd_namespace = var.argocd_namespace
  }))
}

# Create argocd workloads in ArgoCD
resource "kubernetes_manifest" "argocd_workloads" {
  manifest = yamldecode(templatefile("${path.module}/argocd-application.yml", {
    argocd_namespace = var.argocd_namespace
    vpc_id           = local.vpc_id
    region           = local.region
  }))
}

# TODO: Move this to the manifest repo
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

