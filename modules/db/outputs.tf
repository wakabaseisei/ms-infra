output "db_cluster_resource_id" {
    value = aws_rds_cluster.cluster.id
}

output "db_cluster_endpoint" {
  value = aws_rds_cluster.cluster.endpoint
}

output "lambda_migration_security_group_id" {
  value = aws_security_group.lambda_migration_security_group.id
}
