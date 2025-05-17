data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "application" {
    source = "../../../modules/application"

    namespace = local.service_name
    github_repository_name = local.service_name
    # NOTE: Disabled to reduce costs. Uncomment out only when used.
    # eks = {
    #   service_account_name = local.service_name
    #   oidc_provider = data.terraform_remote_state.common.outputs.eks_oidc_provider
    # }
}

# NOTE: Disabled to reduce costs. Uncomment out only when used.
# module "aurora" {
#   source = "../../../modules/database"
#   cluster_identifier = local.service_name
#   cluster_vpc_id = data.terraform_remote_state.common.outputs.vpc_id
#   cluster_instances_subnet_ids = data.terraform_remote_state.common.outputs.database_subnets
#   database_name = local.service_name_letter
#   reader_instance_classes = [ "db.serverless", "db.serverless" ]
#   database_username = local.service_name
#   migration_lambda = {
#     # CIで置き換えるため、仮のURLとして設定
#     image_url = "148761642613.dkr.ecr.ap-northeast-1.amazonaws.com/ms-user"
#     # CIで置き換えるため、仮のタグとして設定
#     image_tag = "dev-20250501-135131-c9ab3e7"
#     entry_point = ["/bin/migrate-lambda"]
#   }
#   database_access_client = {
#     role = module.application.irsa_role_name
#     security_group_id = data.terraform_remote_state.common.outputs.eks_cluster_security_group_id
#   }
# }
