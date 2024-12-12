resource "aws_ecr_repository" "repo" {
  name                 = var.namespace
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
