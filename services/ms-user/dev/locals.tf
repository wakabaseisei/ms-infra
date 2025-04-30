locals {
    service_name = "ms-user"
    env = "dev"
    service_name_env = "${local.service_name}-${local.env}"
    service_name_letter = "MSUser"
}
