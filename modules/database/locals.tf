locals {
  create_migration = var.migration_lambda != null
  create_database_access = var.database_access_client != null
  create_iam_database_auth = local.create_database_access || local.create_migration
}

locals {
  ms_db_user_generator = {
    image_tag = "dev-20250523-205951-0635732"
  }
}

locals {
  rds_ca_cert_identifier = "rds-ca-rsa2048-g1"
}