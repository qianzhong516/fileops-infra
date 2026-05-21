# This file is to grant permissions to the service account used by ArgoCD Repo-server

// Pod identity
resource "aws_eks_pod_identity_association" "argocd_repo_server" {
  cluster_name = local.cluster_name
  namespace    = var.argocd_namespace
  // This SA is created via Helm
  service_account = "argocd-repo-server"
  region          = local.region
  role_arn        = aws_iam_role.argocd_repo_server.arn
}

// IAM role
resource "aws_iam_role" "argocd_repo_server" {
  name = "argocd-repo-server-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEksPodIdentityAssumeRole"
        Effect = "Allow"
        Action = ["sts:AssumeRole", "sts:TagSession"]
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      },
    ]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "argocd_repo_server_attach" {
  role       = aws_iam_role.argocd_repo_server.name
  policy_arn = aws_iam_policy.argocd_repo_server.arn
}

resource "aws_iam_policy" "argocd_repo_server" {
  name = "argocd-repo-server-iam-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowKmsDecryptForSops"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = "arn:aws:kms:ap-southeast-2:665303624691:alias/fileops-dev"
      }
    ]
  })
}
