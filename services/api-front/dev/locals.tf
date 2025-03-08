locals {
    service_name = "api-front"
    env = "dev"
    service_name_env = "${local.service_name}-${local.env}"
    service_name_letter = "ApiFront"
}

locals {
  rds_master_password = jsondecode(data.aws_secretsmanager_secret_version.rds_master_password.secret_string)["password"]
}
