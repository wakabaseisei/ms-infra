data "aws_organizations_organization" "main" {}
data "aws_caller_identity" "current" {}

resource "aws_organizations_organizational_unit" "foundational" {
  name      = "Foundational"
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_organizational_unit" "additional" {
  name      = "Additional"
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = aws_organizations_organizational_unit.foundational.id
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = aws_organizations_organizational_unit.additional.id
}

resource "aws_organizations_account" "audit" {
  name              = "Audit"
  email             = "wakabaseisei+audit@gmail.com"
  parent_id         = aws_organizations_organizational_unit.security.id
  close_on_deletion = true
}

resource "aws_organizations_account" "log_archive" {
  name              = "Log-Archive"
  email             = "wakabaseisei+log-archive@gmail.com"
  parent_id         = aws_organizations_organizational_unit.security.id
  close_on_deletion = true
}
