locals {
  private_alb_http_port = var.private_alb_http_port
  private_alb_https_port = var.private_alb_https_port
}

locals {
  origin_id = "vpc-origin" 
  vpc_origin_endpoint_config_name = "${var.vpc_origin_prefix}-vpc-origin"
}
