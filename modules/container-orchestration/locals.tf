locals {
  argocd = {
    enable = var.enable_argocd
    namespace = var.argocd_namespace
    helm = {
      repository = "https://argoproj.github.io/argo-helm"
      chart_name = var.argocd_chart_name
      chart_version = var.argocd_chart_version
      release_name = var.argocd_release_name
    }
  }
}