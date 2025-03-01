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
  default = null
}

variable "rds" {
  type = object({
    cluster_id = string
    cluster_endpoint = string
    db_port = string
    db_user_name = string
    db_name = string
    database_subnets = set(string)
    lambda_migration_security_group_id = string
  })
  default = null
}
