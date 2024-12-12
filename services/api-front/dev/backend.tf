terraform {
  backend "s3" {
    bucket = "ms-infra-services-${local.service_name_env}"
    key    = "backend/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
