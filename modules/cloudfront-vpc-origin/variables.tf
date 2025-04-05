variable "private_alb_arn" {
  type = string
}

variable "private_alb_domain_name" {
  type = string
}

variable "private_alb_http_port" {
  type = number
}

variable "private_alb_https_port" {
  type = number
}

variable "vpc_origin_prefix" {
  type = string
}
