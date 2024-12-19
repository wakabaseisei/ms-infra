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
