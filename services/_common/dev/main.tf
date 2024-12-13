data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "github" {
    source = "../../../modules/github"
    account_id = data.aws_caller_identity.current.account_id
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.env}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # NAT Gateway is disabled (default value).
  # Explicitly set to false to indicate it is not in use.
  enable_nat_gateway = false

  # For use with AWS Load Balancer Controller
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
 
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"
  cluster_version = "1.31"
  cluster_name    = "${local.env}-eks"
  vpc_id          = module.vpc.vpc_id
  enable_irsa     = true
}

module "cluster" {
  source = "../../../modules/cluster"
}
