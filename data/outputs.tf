output "db_host" {
  value = module.rds.db_instance_endpoint
}

output "rds_secret_arn" {
  value = module.rds.db_instance_master_user_secret_arn
}
