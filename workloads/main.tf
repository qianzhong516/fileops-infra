# Create app workloads in ArgoCD
resource "kubernetes_manifest" "app_workloads" {
  manifest = yamldecode(file("${path.module}/manifests/application.yml"))
}

# TODO: Move this to the manifest repo
resource "kubernetes_manifest" "git_repo_secret" {
  manifest = {
    apiVersion = "v1"
    kind       = "Secret"
    metadata = {
      name      = "private-repo"
      namespace = "argocd"
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
