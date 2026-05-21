module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.20.0"

  name               = "fileops-cluster"
  kubernetes_version = "1.33"

  endpoint_private_access = true
  endpoint_public_access  = true

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
      // TODO: maybe import this data from a remote state?
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
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.medium"]

      min_size     = 2
      max_size     = 2
      desired_size = 2

      # TODO: delete this after testing
      create_iam_role = true
      iam_role_additional_policies = {
        ssm = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
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


# Set up a managed RDS DB instance
# module "rds" {
#   source  = "terraform-aws-modules/rds/aws"
#   version = "7.2.0"

#   identifier = "fileops-postgres"

#   engine               = "postgres"
#   engine_version       = "18"
#   family               = "postgres18"
#   major_engine_version = "18"
#   instance_class       = "db.t4g.micro"

#   allocated_storage = 20
#   storage_type      = "gp3"

#   db_name  = "appdb"
#   username = "postgres"
#   port     = 5432

#   manage_master_user_password = true

#   multi_az                = false
#   publicly_accessible     = false
#   skip_final_snapshot     = true
#   deletion_protection     = false
#   backup_retention_period = 0

#   create_db_subnet_group = true
#   subnet_ids             = values(aws_subnet.private_subnet)[*].id

#   vpc_security_group_ids = [aws_security_group.rds.id]

#   tags = local.tags
# }

# resource "aws_security_group" "rds" {
#   name   = "fileops-rds-sg"
#   vpc_id = aws_vpc.main.id

#   ingress {
#     from_port       = 5432
#     to_port         = 5432
#     protocol        = "tcp"
#     security_groups = [module.eks.node_security_group_id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = local.tags
# }
