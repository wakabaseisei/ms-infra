variable "argocd_namespace" {
  type        = string
  description = "ArgoCD namespace"
  default     = "argocd"
}

variable "argocd_chart_name" {
  type = string
  description = "ArgoCD chart name"
  default = "argo-cd"
}

variable "argocd_chart_version" {
  type = string
  description = "ArgoCD chart version"
  default = "7.7.16"
}

variable "argocd_release_name" {
  type = string
  description = "ArgoCD helm release name"
  default = "argocd"
}
