data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "tenant" {
    source = "../../../modules/tenant"

    namespace = local.service_name
    account_id = data.aws_caller_identity.current.account_id
    github_repository_name = local.service_name
    // NOTE: Disabled to reduce costs. Uncomment out only when used.
    # eks = {
    #   service_account_name = local.service_name
    #   oidc_provider = data.terraform_remote_state.common.outputs.eks_oidc_provider
    # }
}

// NOTE: Disabled to reduce costs. Uncomment out only when used.
# module "cloudfront-vpc-origin" {
#   source = "../../../modules/cloudfront-vpc-origin"
#   vpc_origin_prefix = local.service_name
# }
