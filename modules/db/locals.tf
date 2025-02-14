locals {
  rds = {
    cluster_identifier = var.cluster_identifier
    cluster_vpc_id = var.cluster_vpc_id
    cluster_instances_subnet_ids = var.cluster_instances_subnet_ids
    cluster_ingress_allowed_security_groups = var.cluster_ingress_allowed_security_groups
    engine = var.engine
    engine_mode = var.engine_mode
    engine_version = var.engine_version
    database_name = var.database_name
    master_username = var.master_username
    writer_instance_class_type = var.writer_instance_class_type

    reader_instance_classes = var.reader_instance_classes
    serverlessv2_scaling_configuration = var.serverlessv2_scaling_configuration
  }
}
