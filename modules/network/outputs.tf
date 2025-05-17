output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = compact(aws_subnet.private[*].cidr_block)
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = aws_subnet.database[*].id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = aws_route_table.private[*].id
}
