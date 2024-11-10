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

data "aws_iam_policy_document" "github_actions" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::ms-infra-platform"]
  }

  statement {
    effect    = "Allow"
    actions   = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::ms-infra-platform/*"
    ]
  }
}


resource "aws_iam_policy" "github_actions" {
  name        = "github-actions-policy"
  description = "A GitHub Actions policy"
  policy      = data.aws_iam_policy_document.github_actions.json
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions.arn
}
