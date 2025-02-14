locals {
    account_id = var.account_id
    namespace = var.namespace
    rds = {
        cluster_id = var.rds.cluster_id
        db_user_name = var.rds.db_user_name
    }
    eks = {
        service_account_name = var.eks.service_account_name
        oidc_provider = var.eks.oidc_provider
    }
}
