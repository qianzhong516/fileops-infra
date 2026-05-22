# Create the cluster encryption key
resource "aws_kms_alias" "eks_encryption_key_alias" {
  name          = "alias/fileops-cluster"
  target_key_id = aws_kms_key.eks_encryption_key.key_id
}

resource "aws_kms_key" "eks_encryption_key" {
  description             = "An symmetric KMS key for EKS encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  lifecycle {
    prevent_destroy = true
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Default"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::665303624691:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "KeyAdministration"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::665303624691:role/tf_oidc_role"
        }
        Action = [
          "kms:Update*",
          "kms:UntagResource",
          "kms:TagResource",
          "kms:ScheduleKeyDeletion",
          "kms:Revoke*",
          "kms:ReplicateKey",
          "kms:Put*",
          "kms:List*",
          "kms:ImportKeyMaterial",
          "kms:Get*",
          "kms:Enable*",
          "kms:Disable*",
          "kms:Describe*",
          "kms:Delete*",
          "kms:Create*",
          "kms:CancelKeyDeletion"
        ]
        Resource = "*"
      }
    ]
  })
}

// Grant the cluster role key usage
resource "aws_kms_grant" "eks_cluster_role_grant" {
  name              = "eks-cluster-role-grant"
  key_id            = aws_kms_key.eks_encryption_key.key_id
  grantee_principal = module.eks.cluster_iam_role_arn
  operations = [
    "ReEncryptFrom",
    "ReEncryptTo",
    "GenerateDataKey",
    "GenerateDataKeyWithoutPlaintext",
    "GenerateDataKeyPair",
    "GenerateDataKeyPairWithoutPlaintext",
    "Encrypt",
    "DescribeKey",
    "Decrypt"
  ]
}
