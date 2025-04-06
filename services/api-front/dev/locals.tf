locals {
    service_name = "api-front"
    env = "dev"
    service_name_env = "${local.service_name}-${local.env}"
    service_name_letter = "ApiFront"
}
