terraform {
  backend "s3" {
    bucket = "ms-infra-services-ms-user-dev"
    key    = "backend/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
