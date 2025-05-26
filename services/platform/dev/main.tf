data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "tf-pipeline" {
    source = "../../../modules/tf-pipeline"
}

module "db_user_generator" {
  source = "../../../modules/database-user-generator"
}

module "vpc" {
  source = "../../../modules/network"

  name = "${local.env}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]

  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "container-orchestration" {
  source = "../../../modules/container-orchestration"
  env = local.env
  vpc_id = module.vpc.vpc_id
  cluster_vpc_subnets = module.vpc.private_subnets
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  private_route_table_ids = module.vpc.private_route_table_ids

  enable_argocd = true
}
