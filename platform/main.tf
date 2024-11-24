data "aws_organizations_organization" "main" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "github" {
    source = "../modules/github"
    account_id = data.aws_caller_identity.current.account_id
}
