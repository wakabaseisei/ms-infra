terraform {
  backend "s3" {
    bucket = "ms-infra-services-api-front-dev"
    key    = "backend/terraform.tfstate"
    region = "ap-northeast-1"

    profile = "dev"
  }
}
