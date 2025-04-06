locals {
    service_name = "api-front"
    env = "dev"
    service_name_env = "${local.service_name}-${local.env}"
    service_name_letter = "ApiFront"
    private_alb_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:148761642613:loadbalancer/app/k8s-apifront-apifront-41906da9c8/3259883416a8ec0b"
}
