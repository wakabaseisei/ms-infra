locals {
  cluster_identifier = var.cluster_identifier
  cluster_vpc_id = var.cluster_vpc_id
  cluster_instances_subnet_ids = var.cluster_instances_subnet_ids
  engine = var.engine
  engine_mode = var.engine_mode
  engine_version = var.engine_version
  database_name = var.database_name
  master_username = var.master_username
  writer_instance_class_type = var.writer_instance_class_type

  reader_instance_classes = var.reader_instance_classes
  serverlessv2_scaling_configuration = var.serverlessv2_scaling_configuration

  migration_lambda = var.migration_lambda
  database_username = var.database_username
  database_access_client = var.database_access_client

  account_id = var.account_id

  create_migration = var.migration_lambda != null
  create_database_access = var.database_access_client != null

  create_iam_database_auth = local.create_database_access || local.create_migration
}

locals {
  ms_db_user_generator = {
    // TODO:
    image_tag = "TODO"
  }
}