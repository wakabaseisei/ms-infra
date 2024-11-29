data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "tenant" {
    source = "../../../modules/tenant"
    container_repository_name = local.service_name_env
}
