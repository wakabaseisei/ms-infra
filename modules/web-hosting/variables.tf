variable "github_repository_name" {
  type        = string
  description = "The name of the GitHub repository. Used to create a unique S3 bucket name and IAM role name for GitHub Actions deployment."
}
