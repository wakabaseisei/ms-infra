resource "aws_ecr_repository" "repo" {
  name                 = "${var.container_repository_name}"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
