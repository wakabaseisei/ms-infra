<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_vpc_origin.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_vpc_origin) | resource |
| [aws_vpc_security_group_ingress_rule.vpc_origin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_alb.private_alb_for_vpc_origin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/alb) | data source |
| [aws_security_group.private_alb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_security_group.vpc_origin_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_alb_http_port"></a> [private\_alb\_http\_port](#input\_private\_alb\_http\_port) | The HTTP port of the private Application Load Balancer (ALB) that CloudFront will forward requests to. | `number` | `80` | no |
| <a name="input_private_alb_https_port"></a> [private\_alb\_https\_port](#input\_private\_alb\_https\_port) | The HTTPS port of the private Application Load Balancer (ALB). While the origin protocol policy is set to 'http-only', this port is still configured in the CloudFront origin. | `number` | `443` | no |
| <a name="input_private_alb_type"></a> [private\_alb\_type](#input\_private\_alb\_type) | The type of the private Application Load Balancer (ALB) to use as the CloudFront origin. Currently, only 'ingress.eks.amazonaws.com' is supported. | `string` | `"ingress.eks.amazonaws.com"` | no |
| <a name="input_vpc_origin_prefix"></a> [vpc\_origin\_prefix](#input\_vpc\_origin\_prefix) | A prefix to be used for naming the CloudFront VPC origin endpoint configuration. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->