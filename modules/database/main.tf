data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_rds_cluster" "cluster" {
  cluster_identifier = var.cluster_identifier
  engine             = var.engine
  engine_mode        = var.engine_mode
  engine_version     = var.engine_version
  database_name      = var.database_name
  master_username    = var.master_username
  db_subnet_group_name = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds_cluster_security_group.id]
  iam_database_authentication_enabled = true
  manage_master_user_password = true
  storage_encrypted  = true
  skip_final_snapshot = true
  apply_immediately = true

  dynamic "serverlessv2_scaling_configuration" {
    for_each = var.serverlessv2_scaling_configuration == null ? [] : [true]
    content {
      max_capacity             = local.serverlessv2_scaling_configuration.max_capacity
      min_capacity             = local.serverlessv2_scaling_configuration.min_capacity
      seconds_until_auto_pause = local.serverlessv2_scaling_configuration.seconds_until_auto_pause
    }
  }
}

resource "aws_rds_cluster_instance" "writer" {
  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = var.writer_instance_class_type
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.rds.name
  ca_cert_identifier = local.rds_ca_cert_identifier
}

resource "aws_rds_cluster_instance" "reader" {
  for_each = { for idx, class in var.reader_instance_classes : idx => class }

  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = each.value
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.rds.name
  ca_cert_identifier = local.rds_ca_cert_identifier
}

resource "aws_db_subnet_group" "rds" {
  name = "rds"
  subnet_ids = var.cluster_instances_subnet_ids
}

resource "aws_security_group" "rds_cluster_security_group" {
  vpc_id = var.cluster_vpc_id
  name   = "rds-security-group"
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.rds_cluster_security_group.id
}

// Create DB User
resource "aws_lambda_function" "db_user_generator_lambda" {
  function_name = "db-user-generator-lambda-${var.cluster_identifier}"
  role          = aws_iam_role.db_user_generator_lambda_invoke_role.arn
  package_type  = "Image"
  image_uri = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/ms-db-user-generator:${local.ms_db_user_generator.image_tag}"
  timeout       = 900

  vpc_config {
    subnet_ids         = var.cluster_instances_subnet_ids
    security_group_ids = [aws_security_group.lambda_security_group.id]
  }

  environment {
    variables = {
      DB_SECRET_ARN = aws_rds_cluster.cluster.master_user_secret[0].secret_arn
      DB_HOST = aws_rds_cluster.cluster.endpoint
      DB_PORT = 3306
      DB_NAME = var.database_name
    }
  }

  depends_on = [ aws_rds_cluster.cluster, aws_rds_cluster_instance.writer ]
}

resource "terraform_data" "db_user_generator_lambda_invoke" {
  triggers_replace = [
    aws_lambda_function.db_user_generator_lambda.id
  ]

  provisioner "local-exec" {
    command = <<EOT
    aws lambda invoke \
      --function-name ${aws_lambda_function.db_user_generator_lambda.function_name} \
      --region ${data.aws_region.current.name} \
      --cli-binary-format raw-in-base64-out \
      --payload '{ "username": "${var.database_username}" }' \
      /dev/stdout
    EOT
  }
}

resource "aws_iam_role" "db_user_generator_lambda_invoke_role" {
  name = "user-gen-lambda-role-${var.cluster_identifier}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access_execution_role_to_db_gen_lambda_role" {
  role       = aws_iam_role.db_user_generator_lambda_invoke_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "get_secret_to_db_gen_lambda_role" {
  role       = aws_iam_role.db_user_generator_lambda_invoke_role.name
  policy_arn = aws_iam_policy.secretsmanager_get_secret.arn
}

resource "aws_iam_policy" "secretsmanager_get_secret" {
  name        = "secretsmanager-get-secret"
  description = "Policy to allow access to Secrets Manager GetSecretValue"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "secretsmanager:GetSecretValue"
        Resource = aws_rds_cluster.cluster.master_user_secret[0].secret_arn
      }
    ]
  })
}

resource "aws_vpc_security_group_ingress_rule" "allow_lambda_security_group" {
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.rds_cluster_security_group.id
  referenced_security_group_id = aws_security_group.lambda_security_group.id
}

resource "aws_security_group" "lambda_security_group" {
  vpc_id = var.cluster_vpc_id
  name   = "lambda-security-group-${var.cluster_identifier}"
}

resource "aws_vpc_security_group_egress_rule" "lambda_security_group_rule" {
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.lambda_security_group.id
}

// IAM Database Authentication(Optional)
data "aws_iam_policy_document" "rds_iam_auth" {
  count = local.create_iam_database_auth ? 1 : 0
  statement {
    effect = "Allow"
    actions = ["rds-db:connect"]
    resources = [
      "arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_rds_cluster.cluster.cluster_resource_id}/${var.database_username}"
    ]
  }
}

resource "aws_iam_policy" "rds_iam_auth" {
  count = local.create_iam_database_auth ? 1 : 0
  name   = "rds-iam-auth-${var.cluster_identifier}"
  policy = data.aws_iam_policy_document.rds_iam_auth[0].json
}

// DB Access(Optional)
resource "aws_iam_role_policy_attachment" "rds_iam_auth_attach" {
  count = local.create_database_access ? 1 : 0
  role       = local.database_access_client.role
  policy_arn = aws_iam_policy.rds_iam_auth[0].arn
}

resource "aws_vpc_security_group_ingress_rule" "allow_database_access_client_security_group" {
  count = local.create_database_access ? 1 : 0
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.rds_cluster_security_group.id
  referenced_security_group_id = local.database_access_client.security_group_id
}

// DB Migration(Optional)
resource "aws_lambda_function" "migration_lambda" {
  count = local.create_migration ? 1 : 0
  function_name = "migrate-lambda-${var.cluster_identifier}"
  role          = aws_iam_role.lambda_migration_role[0].arn
  package_type  = "Image"
  // https://qiita.com/Kyohei-takiyama/items/86e71e1f4f989bbfc665
  image_uri     = "${local.migration_lambda.image_url}:${local.migration_lambda.image_tag}"
  timeout       = 900

  vpc_config {
    subnet_ids         = var.cluster_instances_subnet_ids
    security_group_ids = [aws_security_group.lambda_security_group.id]
  }

  environment {
    variables = {
      DB_HOST = aws_rds_cluster.cluster.endpoint
      DB_PORT = 3306
      DB_USER = var.database_username
      DB_NAME = var.database_name
    }
  }

  image_config {
    entry_point = local.migration_lambda.entry_point
    # entry_point = ["/bin/migrate-cli", "up"]
  }
}

resource "aws_iam_role" "lambda_migration_role" {
  count = local.create_migration ? 1 : 0
  name = "lambda-migration-role-${var.cluster_identifier}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_iam_auth_attach_to_lambda" {
  count = local.create_migration ? 1 : 0
  role       = aws_iam_role.lambda_migration_role[0].name
  policy_arn = aws_iam_policy.rds_iam_auth[0].arn
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access_execution_role_to_migration_lambda_role" {
  count = local.create_migration ? 1 : 0
  role       = aws_iam_role.lambda_migration_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
