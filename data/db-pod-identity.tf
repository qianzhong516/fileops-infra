# Create an IAM role which will be assumed by backend pods to fetch db credentials
resource "aws_iam_role" "backend_db_secret" {
  name = "fileops-backend-db-secret-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"

        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Principal = {
          Service = "pods.eks.amazonaws.com"
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

# Map that service account with the IAM role via pod identity association
resource "aws_eks_pod_identity_association" "backend_db_secret" {
  cluster_name    = local.cluster_name
  namespace       = "dev"
  service_account = "backend-aws-secret"
  role_arn        = aws_iam_role.backend_db_secret.arn
}
