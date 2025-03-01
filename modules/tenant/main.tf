data "aws_region" "current" {}

// use for GitHub Actions docker image push workflow.
resource "aws_iam_role" "github_actions_docker_image_push" {
  name = "github_actions_docker_image_push-${var.github_repository_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${var.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : "repo:wakabaseisei/${var.github_repository_name}:ref:refs/heads/main"
          },
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_docker_image_push" {
  role       = aws_iam_role.github_actions_docker_image_push.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

// ECR
resource "aws_ecr_repository" "repo" {
  name                 = var.namespace
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

// IRSA
// https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest#output_oidc_provider_arn
resource "aws_iam_role" "irsa" {
  count = local.eks == null ? 0 : 1
  name = "irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${local.account_id}:oidc-provider/${local.eks.oidc_provider}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.eks.oidc_provider}:sub" = "system:serviceaccount:${local.namespace}:${local.eks.service_account_name}"
          }
        }
      }
    ]
  })
}

// RDS(Optional)
// IAM Database Authentication
data "aws_iam_policy_document" "rds_iam_auth" {
  count = local.rds == null ? 0 : 1
  statement {
    effect = "Allow"
    actions = ["rds-db:connect"]
    resources = [
      "arn:aws:rds-db:${data.aws_region.current.name}:${local.account_id}:dbuser/${local.rds.cluster_id}/${local.rds.db_user_name}"
    ]
  }
}

resource "aws_iam_policy" "rds_iam_auth" {
  count = local.rds == null ? 0 : 1
  name   = "rds-iam-auth-${local.rds.cluster_id}"
  policy = data.aws_iam_policy_document.rds_iam_auth[0].json
}

resource "aws_iam_role_policy_attachment" "rds_iam_auth_attach" {
  count = local.rds == null ? 0 : 1
  role       = aws_iam_role.irsa[0].name
  policy_arn = aws_iam_policy.rds_iam_auth[0].arn
}

// DB Migration
resource "aws_lambda_function" "migration_lambda" {
  count = local.rds == null ? 0 : 1
  function_name = "golang-migrate-lambda"
  role          = aws_iam_role.lambda_migration_role[0].arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.repo.repository_url}:latest"
  timeout       = 900

  vpc_config {
    subnet_ids         = local.rds.database_subnets
    security_group_ids = [local.rds.lambda_migration_security_group_id]
  }

  environment {
    variables = {
      DB_HOST = local.rds.cluster_endpoint
      DB_PORT = local.rds.db_port
      DB_USER = local.rds.db_user_name
      DB_NAME = local.rds.db_name
      AWS_REGION = data.aws_region.current.name
    }
  }

  image_config {
    entry_point = ["/bin/migrate-cli", "up"]
  }
}

resource "aws_iam_role" "lambda_migration_role" {
  count = local.rds == null ? 0 : 1
  name = "lambda-migration-role"

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
  count = local.rds == null ? 0 : 1
  role       = aws_iam_role.lambda_migration_role[0].name
  policy_arn = aws_iam_policy.rds_iam_auth[0].arn
}

