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

# module "eks" {
#   source          = "terraform-aws-modules/eks/aws"

#   version = "~> 20.31"
#   cluster_version = "1.31"

#   cluster_name    = "${local.env}-eks"

#   vpc_id          = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnets

#   cluster_endpoint_public_access = true
#   cluster_endpoint_private_access = true
#   authentication_mode = "API"

#   enable_cluster_creator_admin_permissions = true

#   # EKS Auto Mode will create and delete EC2 Managed Instances
#   # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster#compute_config
#   cluster_compute_config = {
#     enabled    = true
#     node_pools = ["general-purpose"]
#   }

#   cloudwatch_log_group_retention_in_days = 3

#   access_entries = {
#     # One access entry with a policy associated
#     local = {
#       principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/ap-northeast-1/AWSReservedSSO_AdministratorAccess_81e4d4a3d70e0c36"

#       policy_associations = {
#         clusteradmin = {
#           policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#           access_scope = {
#             type       = "cluster"
#           }
#         }
#       }
#     }
#   }
# }

module "cluster" {
  source = "../../../modules/cluster"
}
