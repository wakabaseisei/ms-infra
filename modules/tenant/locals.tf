locals {
    account_id = var.account_id
    namespace = var.namespace
    rds = var.rds
    eks = {
        service_account_name = var.eks.service_account_name
        oidc_provider = var.eks.oidc_provider
    }
}
