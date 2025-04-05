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

// NOTE: Disable to reduce cost when eks cluster is not used.
output "eks_oidc_provider" {
  value = module.eks.oidc_provider
}

output "eks_cluster_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}
