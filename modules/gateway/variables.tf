variable "private_alb_http_port" {
  type = number
  default = 80
}

variable "private_alb_https_port" {
  type = number
  default = 443
}

variable "vpc_origin_prefix" {
  type = string
}

# TODO: EKS Ingressで作成されたALBか否かで設定を変える
