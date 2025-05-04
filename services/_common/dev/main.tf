data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "github" {
    source = "../../../modules/github"
    account_id = data.aws_caller_identity.current.account_id
}

module "db_user_generator" {
  source = "../../../modules/docker-image-push"
  account_id = data.aws_caller_identity.current.account_id
  github_repository_name = "ms-db-user-generator"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.env}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]

  // NOTE: Disable to reduce cost when eks cluster is not used.
  # enable_nat_gateway = true

  # For use with AWS Load Balancer Controller
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
 
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# NOTE: For cost-saving purposes, the unused resources are commented out when they are not in use.
module "container" {
  source = "../../../modules/container"
  env = local.env
  cluster_vpc_subnets = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id
  private_route_table_ids = module.vpc.private_route_table_ids
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks

  # enable_argocd = true
}
