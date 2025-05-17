variable "private_alb_http_port" {
  type        = number
  default     = 80
  description = "The HTTP port of the private Application Load Balancer (ALB) that CloudFront will forward requests to."
}

variable "private_alb_https_port" {
  type        = number
  default     = 443
  description = "The HTTPS port of the private Application Load Balancer (ALB). While the origin protocol policy is set to 'http-only', this port is still configured in the CloudFront origin."
}

variable "private_alb_type" {
  type        = string
  default     = "ingress.eks.amazonaws.com"
  description = "The type of the private Application Load Balancer (ALB) to use as the CloudFront origin. Currently, only 'ingress.eks.amazonaws.com' is supported."
  validation {
    condition     = var.private_alb_type == "ingress.eks.amazonaws.com"
    error_message = "The private_alb_type must be 'ingress.eks.amazonaws.com'. Currently, only ALB created by Ingress are supported."
  }
}

variable "vpc_origin_prefix" {
  type        = string
  description = "A prefix to be used for naming the CloudFront VPC origin endpoint configuration."
}
