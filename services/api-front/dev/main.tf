data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "application" {
    source = "../../../modules/application"

    namespace = local.service_name
    account_id = data.aws_caller_identity.current.account_id
    github_repository_name = local.service_name
}

// NOTE: Disabled to reduce costs. Uncomment out only when used.
# module "gateway" {
#   source = "../../../modules/gateway"
#   vpc_origin_prefix = local.service_name
# }
