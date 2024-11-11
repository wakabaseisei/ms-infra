resource "aws_iam_role" "github_actions" {
  name = "github_actions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Principal": {
            "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
            "StringLike": {
                "token.actions.githubusercontent.com:sub": "repo:wakabaseisei/ms-infra:*"
            },
            "StringEquals": {
                "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
            }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
