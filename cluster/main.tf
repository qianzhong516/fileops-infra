module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.20.0"

  name               = "fileops-cluster"
  kubernetes_version = "1.33"

  endpoint_private_access = true
  endpoint_public_access  = true

  # Use a fixed cluster encryption key to avoid key-recreation costs
  create_kms_key = false
  encryption_config = {
    provider_key_arn = aws_kms_alias.eks_encryption_key_alias.target_key_arn
  }

  # explicitly add an admin as an EKS access entry
  access_entries = {
    local_admin = {
      principal_arn = "arn:aws:iam::665303624691:user/eks-training-admin"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }

    tf_oidc_role = {
      principal_arn = "arn:aws:iam::665303624691:role/tf_oidc_role"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  compute_config = {
    # Turn off Auto Mode
    enabled = false
  }

  vpc_id     = aws_vpc.main.id
  subnet_ids = values(aws_subnet.private_subnet)[*].id

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    fileops-node-group = {
      kubernetes_version = "1.33"
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

  tags = merge(var.tags, {
    Name = "fileops-cluster"
  })
}
