data "aws_alb" "private_alb_for_vpc_origin" {
  tags = {
    "ingress.eks.amazonaws.com/resource" = "LoadBalancer"
  }
}

resource "aws_cloudfront_vpc_origin" "alb" {
  vpc_origin_endpoint_config {
    name                   = local.vpc_origin_endpoint_config_name
    arn                    = data.aws_alb.private_alb_for_vpc_origin.arn
    http_port              = var.private_alb_http_port
    https_port             = var.private_alb_https_port
    origin_protocol_policy = "http-only"

    origin_ssl_protocols {
      items    = ["TLSv1.2"]
      quantity = 1
    }
  }
}

resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = data.aws_alb.private_alb_for_vpc_origin.dns_name
    origin_id   = local.origin_id
    vpc_origin_config {
      vpc_origin_id = aws_cloudfront_vpc_origin.alb.id
    }
  }
  enabled = true
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id = "83da9c7e-98b4-4e11-a168-04f0df8e2c65"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

data "aws_security_group" "vpc_origin_sg" {
  name = "CloudFront-VPCOrigins-Service-SG"
  depends_on = [aws_cloudfront_vpc_origin.alb]
}

data "aws_security_group" "private_alb_sg" {
  tags = {
    "ingress.eks.amazonaws.com/resource"= "ManagedLBSecurityGroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_origin" {
  security_group_id            = data.aws_security_group.private_alb_sg.id
  ip_protocol                  = "tcp"
  from_port                    = var.private_alb_http_port
  to_port                      = var.private_alb_http_port
  referenced_security_group_id = data.aws_security_group.vpc_origin_sg.id
}
