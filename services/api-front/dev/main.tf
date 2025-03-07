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
    // NOTE: Disabled to reduce costs. Uncomment out only when used.
    #  rds = {
    #     cluster_id = module.aurora.db_cluster_resource_id
    #     cluster_endpoint = module.aurora.db_cluster_endpoint
    #     db_port = "3306"
    #     db_user_name = local.service_name
    #     db_name = local.service_name_letter
    #     database_subnets = data.terraform_remote_state.common.outputs.database_subnets
    #     lambda_migration_security_group_id = module.aurora.lambda_migration_security_group_id
    # }
}

// NOTE: Disabled to reduce costs. Uncomment out only when used.
# module "aurora" {
#   source = "../../../modules/db"
#   cluster_identifier = local.service_name
#   cluster_vpc_id = data.terraform_remote_state.common.outputs.vpc_id
#   cluster_instances_subnet_ids = data.terraform_remote_state.common.outputs.database_subnets
#   cluster_ingress_allowed_security_groups = [ data.terraform_remote_state.common.outputs.eks_node_security_group_id ]
#   database_name = local.service_name_letter
#   // TODO: もっといい感じに指定したい
#   reader_instance_classes = [ "db.serverless", "db.serverless" ]
# }
