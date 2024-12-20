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

resource "aws_organizations_organizational_unit" "sandbox" {
  name              = "Sandbox"
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_account" "dev" {
  name              = "Dev"
  email             = "wakabaseisei+dev@gmail.com"
  parent_id         = aws_organizations_organizational_unit.sandbox.id
  close_on_deletion = true
}
