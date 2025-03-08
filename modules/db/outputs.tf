output "rds_master_password_secret_arn" {
  value = aws_rds_cluster.cluster.master_user_secret[0].secret_arn
}

output "db_cluster_endpoint" {
  value = aws_rds_cluster.cluster.endpoint
}

output "rds_master_username" {
  value = aws_rds_cluster.cluster.master_username
}
