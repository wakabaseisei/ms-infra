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
