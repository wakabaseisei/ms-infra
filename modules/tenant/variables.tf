variable "namespace" {
  type = string
}

variable "account_id" {
  type = string
}

variable "github_repository_name" {
  type = string
}

variable "eks" {
  type = object({
    service_account_name = optional(string, "*")
    oidc_provider = string
  })
  description = "for OIDC Provider Role IRSA"
}

variable "rds" {
  type = object({
    cluster_id = string
    db_user_name = string
  })
  default = null
}
