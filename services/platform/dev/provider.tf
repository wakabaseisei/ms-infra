terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.96.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.17"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

provider "helm" {
  kubernetes {
    host                   = module.container-orchestration.cluster_endpoint
    cluster_ca_certificate = base64decode(module.container-orchestration.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.container-orchestration.cluster_name]
    }
  }
}
