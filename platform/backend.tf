terraform {
  backend "s3" {
    bucket = "ms-infra-platform"
    key    = "backend/terraform.tfstate"
    region = "ap-northeast-1"

    profile = "admin"
  }
}
