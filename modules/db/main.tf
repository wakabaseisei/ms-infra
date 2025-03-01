resource "aws_rds_cluster" "cluster" {
  cluster_identifier = local.rds.cluster_identifier
  engine             = local.rds.engine
  engine_mode        = local.rds.engine_mode
  engine_version     = local.rds.engine_version
  database_name      = local.rds.database_name
  master_username    = local.rds.master_username
  db_subnet_group_name = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds_cluster_security_group.id]
  iam_database_authentication_enabled = true
  manage_master_user_password = true
  storage_encrypted  = true
  skip_final_snapshot = true
  apply_immediately = true

  dynamic "serverlessv2_scaling_configuration" {
    for_each = local.rds.serverlessv2_scaling_configuration == null ? [] : [true]
    content {
      max_capacity             = local.rds.serverlessv2_scaling_configuration.max_capacity
      min_capacity             = local.rds.serverlessv2_scaling_configuration.min_capacity
      seconds_until_auto_pause = local.rds.serverlessv2_scaling_configuration.seconds_until_auto_pause
    }
  }
}

resource "aws_rds_cluster_instance" "writer" {
  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = local.rds.writer_instance_class_type
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version
}

resource "aws_rds_cluster_instance" "reader" {
  for_each = { for idx, class in local.rds.reader_instance_classes : idx => class }

  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = each.value
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.rds.name
}

resource "aws_db_subnet_group" "rds" {
  name = "rds"
  subnet_ids = local.rds.cluster_instances_subnet_ids
}

resource "aws_security_group" "rds_cluster_security_group" {
  vpc_id = local.rds.cluster_vpc_id
  name   = "rds-security-group"

  ingress {
    protocol  = "tcp"
    from_port = 3306
    to_port   = 3306
    security_groups = concat([aws_security_group.lambda_migration_security_group.id], local.rds.cluster_ingress_allowed_security_groups)
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lambda_migration_security_group" {
  vpc_id = local.rds.cluster_vpc_id
  name   = "lambda-migration-security-group"

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
