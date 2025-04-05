resource "aws_cloudfront_vpc_origin" "alb" {
  vpc_origin_endpoint_config {
    name                   = local.vpc_origin_endpoint_config_name
    arn                    = local.private_alb_arn
    http_port              = local.private_alb_http_port
    https_port             = local.private_alb_https_port
    origin_protocol_policy = "http-only"

    origin_ssl_protocols {
      items    = ["TLSv1.2"]
      quantity = 1
    }
  }
}

resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = local.private_alb_domain_name
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
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
