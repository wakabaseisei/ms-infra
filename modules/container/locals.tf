locals {
  env = var.env
  cluster_vpc_subnets = var.cluster_vpc_subnets
  vpc_id = var.vpc_id
  private_route_table_ids= var.private_route_table_ids
  private_subnets_cidr_blocks= var.private_subnets_cidr_blocks

  argocd = {
    namespace = var.argocd_namespace
    helm = {
      repository = "https://argoproj.github.io/argo-helm"
      chart_name = var.argocd_chart_name
      chart_version = var.argocd_chart_version
      release_name = var.argocd_release_name
    }
  }
}