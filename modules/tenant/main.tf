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
  name = "irsa-${local.namespace}"

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
