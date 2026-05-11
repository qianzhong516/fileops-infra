module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.20.0"

  name               = "fileops-cluster"
  kubernetes_version = "1.33"

  endpoint_private_access = true
  endpoint_public_access  = true

  # Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  compute_config = {
    # Turn off Auto Mode
    enabled = false
  }

  vpc_id     = aws_vpc.main.id
  subnet_ids = values(aws_subnet.private_subnet)[*].id

  # EKS Managed Node Group(s)
  # TODO: grant session manager access
  eks_managed_node_groups = {
    fileops-node-group = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.medium"]

      min_size     = 2
      max_size     = 2
      desired_size = 2
    }
  }

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  tags = merge(local.tags, {
    Name = "fileops-cluster"
  })
}

