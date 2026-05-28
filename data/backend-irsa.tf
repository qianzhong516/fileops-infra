# TODO: Pod Identity Associations don't work properly with Secrets Store CSI Driver. See the issue @ https://github.com/aws/secrets-store-csi-driver-provider-aws/issues/300. Though PR fixes had been submitted, the issue still persist when tested on the release v3.1.0-eksbuild.1.

# Create an IAM role which will be assumed by backend pods to fetch db credentials
resource "aws_iam_role" "backend_db_secret" {
  name = "fileops-backend-db-secret-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["sts:AssumeRoleWithWebIdentity"]
        Principal = {
          Federated = "arn:aws:iam::${local.account_id}:oidc-provider/${local.cluster_oidc_provider}"
        }
        Condition = {
          StringEquals = {
            "${local.cluster_oidc_provider}:aud" = "sts.amazonaws.com"
            "${local.cluster_oidc_provider}:sub" = "system:serviceaccount:dev:backend-db-secrets"
          }
        }
      },
    ]
  })
  tags = local.tags
}

resource "aws_iam_policy" "backend_db_secret" {
  name        = "fileops-backend-db-secret-role-policy"
  description = "Policy for backend pods to fetch secrets from AWS Secret Manager"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = module.rds.db_instance_master_user_secret_arn
      }
    ]
  })
  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "backend_db_secret" {
  policy_arn = aws_iam_policy.backend_db_secret.arn
  role       = aws_iam_role.backend_db_secret.name
}
