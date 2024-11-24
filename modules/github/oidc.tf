resource "aws_iam_openid_connect_provider" "github_actions_deploy" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["thumbprintthumbprintthumbprintthumbprint"]
}
