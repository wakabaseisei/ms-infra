data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "application" {
    source = "../../../modules/application"

    namespace = local.service_name
    github_repository_name = local.service_name
}

module "gateway" {
  source = "../../../modules/gateway"
  vpc_origin_prefix = local.service_name
}
