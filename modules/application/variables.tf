variable "namespace" {
  type = string
  description = "The namespace to be used for naming resources, such as the ECR repository."
}

variable "github_repository_name" {
  type = string
  description = "The name of the GitHub repository. Used in the IAM role name for Docker image push from GitHub Actions. Example: 'ms-user'."
}

variable "eks" {
  type = object({
    service_account_name = optional(string, "*")
    oidc_provider = string
  })
  description = "Configuration for EKS OIDC provider to enable IRSA. Set to null to disable IRSA role creation."
  default = null
}
