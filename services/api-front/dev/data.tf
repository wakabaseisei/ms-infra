data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket = "ms-infra-common-dev"
    key    = "backend/terraform.tfstate"
    region = "ap-northeast-1"
  }
}


data "aws_secretsmanager_secret_version" "rds_master_password" {
  secret_id = module.aurora.rds_master_password_secret_arn
}
