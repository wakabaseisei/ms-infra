terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

provider "mysql" {
  endpoint = "${module.aurora.db_cluster_endpoint}:3306"
  username = module.aurora.rds_master_username
  password = local.rds_master_password
}
