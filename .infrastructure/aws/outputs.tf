output "rds_db_password" {
  value       = nonsensitive(random_password.rds-master-password.result)
  description = "Database Master Password (sensitive)"
}

output "rds_db_host" {
  value       = aws_rds_cluster_instance.main-db-serverless-instance.endpoint
  description = "Database Host"
}