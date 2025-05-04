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
  value = module.container.cluster_oidc_provider
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
}

output "eks_cluster_security_group_id" {
  value = module.container.cluster_security_group_id
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
}
