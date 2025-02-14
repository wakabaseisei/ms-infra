resource "helm_release" "argocd" {
  name = local.argocd.helm.release_name
  repository = local.argocd.helm.repository
  chart = local.argocd.helm.chart_name
  version    = local.argocd.helm.chart_version
  namespace  = local.argocd.namespace
  create_namespace = true
}
