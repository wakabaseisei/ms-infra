data "aws_organizations_organization" "main" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "tf-pipeline" {
    source = "../modules/tf-pipeline"
}
