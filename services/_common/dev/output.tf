output "private_subnets" {
  value = module.vpc.private_subnets
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "eks_fargate_pod_execution_role_arn" {
  value = module.cluster.eks_fargate_pod_execution_role_arn
}
