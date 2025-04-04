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

#     plan = {
#       principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/github_actions_plan"

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

# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id            = module.vpc.vpc_id
#   service_name      = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
#   vpc_endpoint_type = "Interface"
#   subnet_ids        = module.vpc.private_subnets
#   security_group_ids = [aws_security_group.vpc_endpoints.id]
#   private_dns_enabled = true

#   tags = {
#     Name = "ECR-API-Endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id            = module.vpc.vpc_id
#   service_name      = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
#   vpc_endpoint_type = "Interface"
#   subnet_ids        = module.vpc.private_subnets
#   security_group_ids = [aws_security_group.vpc_endpoints.id]
#   private_dns_enabled = true

#   tags = {
#     Name = "ECR-DKR-Endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = module.vpc.vpc_id
#   service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids   = module.vpc.private_route_table_ids

#   tags = {
#     Name = "S3-Gateway-Endpoint"
#   }
# }

# resource "aws_security_group" "vpc_endpoints" {
#   name        = "${local.env}-vpc-endpoints-sg"
#   description = "Security group for VPC endpoints"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = module.vpc.private_subnets_cidr_blocks
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${local.env}-vpc-endpoints-sg"
#   }
# }

# module "cicd" {
#   source = "../../../modules/cicd"
#   depends_on = [
#     module.eks
#   ]
# }
