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
# module "aurora" {
#   source = "../../../modules/db"
#   cluster_identifier = local.service_name
#   cluster_vpc_id = data.terraform_remote_state.common.outputs.vpc_id
#   cluster_instances_subnet_ids = data.terraform_remote_state.common.outputs.database_subnets
#   database_name = local.service_name_letter
#   reader_instance_classes = [ "db.serverless", "db.serverless" ]
#   database_username = local.service_name
#   account_id = data.aws_caller_identity.current.account_id
#   migration_lambda = {
#     # CIで置き換えるため、仮のURLとして設定
#     image_url = "dummy"
#     # CIで置き換えるため、仮のタグとして設定
#     image_tag = "dummy"
#     entry_point = ["/bin/migrate-lambda"]
#   }
# }
