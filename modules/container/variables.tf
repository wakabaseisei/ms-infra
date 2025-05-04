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

variable "env" {
  type = string
  description = ""
}

variable "cluster_vpc_subnets" {
  type = set(string)
  description = "List of subnet IDs. Must be in at least two different availability zones."
}

variable "vpc_id" {
  type = string
}

variable "private_route_table_ids" {
  type = set(string)
}

variable "private_subnets_cidr_blocks" {
  type = list(string)
}

variable "enable_argocd" {
  type = bool
  default = false
}
