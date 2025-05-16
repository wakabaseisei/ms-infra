locals {
  len_public_subnets = length(var.public_subnets)
  create_public_subnets = local.len_public_subnets > 0
  
  len_private_subnets = length(var.private_subnets)
  create_private_subnets = local.len_private_subnets > 0

  len_database_subnets = length(var.database_subnets)
  create_database_subnets = local.len_database_subnets > 0

  nat_gateway_count = var.one_nat_gateway_per_az ? length(var.azs) : local.len_private_subnets
}
