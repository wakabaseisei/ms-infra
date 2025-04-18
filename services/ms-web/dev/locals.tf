locals {
    service_name = "ms-web"
    env = "dev"
    service_name_env = "${local.service_name}-${local.env}"
}
