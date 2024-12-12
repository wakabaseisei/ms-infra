data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "tenant" {
    source = "../../../modules/tenant"

    namespace = local.service_name
    cluster_name = data.terraform_remote_state.common.outputs.cluster_name
    private_subnets = data.terraform_remote_state.common.outputs.private_subnets
    eks_fargate_pod_execution_role_arn = data.terraform_remote_state.common.outputs.eks_fargate_pod_execution_role_arn
}
