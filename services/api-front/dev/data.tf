data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket = "ms-infra-common-dev"
    key    = "backend/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
