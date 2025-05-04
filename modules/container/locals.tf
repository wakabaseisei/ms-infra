locals {
  env = var.env
  cluster_vpc_subnets = var.cluster_vpc_subnets
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