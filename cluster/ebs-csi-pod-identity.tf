resource "aws_eks_pod_identity_association" "ebs" {
  cluster_name = module.eks.cluster_name
  namespace    = "kube-system"
  // This SA is created via Helm
  service_account = "ebs-csi-controller-sa"
  region          = var.region
  role_arn        = aws_iam_role.ebs.arn
}


resource "aws_iam_role" "ebs" {
  name = "eks-ebs-csi-driver-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole", "sts:TagSession"]
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}


resource "aws_iam_policy_attachment" "ebs" {
  name       = "eks-ebs-csi-driver-policy"
  roles      = [aws_iam_role.ebs.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicyV2"
}
