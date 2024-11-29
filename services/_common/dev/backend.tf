terraform {
  backend "s3" {
    bucket = "ms-infra-common-dev"
    key    = "backend/terraform.tfstate"
    region = "ap-northeast-1"

    profile = "dev"
  }
}
