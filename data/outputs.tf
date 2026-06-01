output "db_host" {
  value = module.rds.db_instance_address
}

output "rds_secret_name" {
  value = data.aws_secretsmanager_secret.db_secret.name
}
