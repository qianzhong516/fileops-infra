# This file is to grant permissions to the service account used by ArgoCD Repo-server to perform SOPS operations

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
        Resource = "arn:aws:kms:ap-southeast-2:665303624691:key/ddb3f1ef-5194-4fa2-b4e1-e914831a249b"
      }
    ]
  })
}

# SOPS key for encrypting Kubernetes secrets
resource "aws_kms_alias" "sops_key_alias" {
  name          = "alias/fileops-dev"
  target_key_id = aws_kms_key.sops_key.key_id
}

resource "aws_kms_key" "sops_key" {
  description             = "An symmetric encryption KMS key for SOPs"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  # lifecycle {
  #   prevent_destroy = true
  # }

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::665303624691:role/tf_oidc_role", "arn:aws:iam::665303624691:user/eks-training-admin"
          ]
        },
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowArgoCDRepoServerDecrypt"
        Effect = "Allow"
        Principal = {
          AWS = [
            aws_iam_role.argocd_repo_server.arn
          ]
        }
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
      # {
      #   Sid    = "Allow administration of the key"
      #   Effect = "Allow"
      #   Principal = {
      #     AWS = "arn:aws:iam::665303624691:user/eks-training-admin"
      #   },
      #   Action = [
      #     "kms:ReplicateKey",
      #     "kms:Create*",
      #     "kms:Describe*",
      #     "kms:Enable*",
      #     "kms:List*",
      #     "kms:Put*",
      #     "kms:Update*",
      #     "kms:Revoke*",
      #     "kms:Disable*",
      #     "kms:Get*",
      #     "kms:Delete*",
      #     "kms:ScheduleKeyDeletion",
      #     "kms:CancelKeyDeletion"
      #   ],
      #   Resource = "*"
      # }
    ]
  })
  tags = merge(local.tags, {
    Name        = "fileops-sops-master-key"
    Environment = "dev"
  })
}
