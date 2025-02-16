output "private_subnets" {
  value = module.vpc.private_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
  description = "List of IDs of database subnets"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

# output "eks_oidc_provider" {
#   value = module.eks.oidc_provider
# }

# output "eks_node_security_group_id" {
#   value = module.eks.node_security_group_id
# }
