# Set up a managed RDS DB instance
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.0"

  identifier = "fileops-postgres"

  engine               = "postgres"
  engine_version       = "18"
  family               = "postgres18"
  major_engine_version = "18"
  instance_class       = "db.t4g.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "fileopsdb"
  username = "postgres"
  port     = 5432

  manage_master_user_password = true

  multi_az                = false
  publicly_accessible     = false
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0

  create_db_subnet_group = true
  subnet_ids             = local.private_subnet_ids

  vpc_security_group_ids = [aws_security_group.rds.id]

  tags = local.tags
}

resource "aws_security_group" "rds" {
  name   = "fileops-rds-sg"
  vpc_id = local.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [local.cluster_node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}
