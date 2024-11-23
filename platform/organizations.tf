data "aws_organizations_organization" "main" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_organizations_organizational_unit" "foundational" {
  name      = "Foundational"
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_account" "audit" {
  name              = "Audit"
  email             = "wakabaseisei+audit@gmail.com"
  parent_id         = aws_organizations_organizational_unit.foundational.id
  close_on_deletion = true
}

resource "aws_organizations_account" "log_archive" {
  name              = "Log-Archive"
  email             = "wakabaseisei+log-archive@gmail.com"
  parent_id         = aws_organizations_organizational_unit.foundational.id
  close_on_deletion = true
}
