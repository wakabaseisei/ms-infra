variable "env" {
  type = string
  description = "The environment name (e.g., dev, staging, prod). Used as a prefix for naming EKS and related resources."
}

variable "cluster_vpc_subnets" {
  type = set(string)
  description = "A set of subnet IDs for the EKS cluster. These subnets should span at least two different Availability Zones for high availability."
}

variable "vpc_id" {
  type = string
  description = "The ID of the VPC where the EKS cluster and related resources will be deployed."
}

variable "private_route_table_ids" {
  type = set(string)
  description = "A set of IDs of the private route tables associated with the subnets used by the EKS cluster for S3 Gateway Endpoint."
}

variable "private_subnets_cidr_blocks" {
  type = list(string)
  description = "A list of CIDR blocks for the private subnets used by the EKS cluster, allowing ingress to VPC Endpoints."
}

variable "enable_argocd" {
  type = bool
  default = false
  description = "A boolean flag to enable or disable the deployment of Argo CD on the EKS cluster."
}

variable "argocd_namespace" {
  type        = string
  description = "The Kubernetes namespace where Argo CD will be installed."
  default     = "argocd"
}

variable "argocd_chart_name" {
  type = string
  description = "The name of the Helm chart used to deploy Argo CD."
  default = "argo-cd"
}

variable "argocd_chart_version" {
  type = string
  description = "The version of the Argo CD Helm chart to be deployed."
  default = "7.7.16"
}

variable "argocd_release_name" {
  type = string
  description = "The Helm release name for the Argo CD deployment."
  default = "argocd"
}
