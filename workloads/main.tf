# Create app workloads in ArgoCD
resource "kubernetes_manifest" "app_workloads" {
  manifest = yamldecode(templatefile("${path.module}/manifests/application.yml", {
    argocd_namespace = var.argocd_namespace
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

# Create argocd workloads in ArgoCD
resource "kubernetes_manifest" "argocd_workloads" {
  manifest = yamldecode(templatefile("${path.module}/manifests/argocd-application.yml", {
    argocd_namespace = var.argocd_namespace
    vpc_id           = local.vpc_id
    region           = local.region
  }))
}
