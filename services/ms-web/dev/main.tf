data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "hosting" {
  source = "../../../modules/web-hosting"
  github_repository_name = local.service_name
}
