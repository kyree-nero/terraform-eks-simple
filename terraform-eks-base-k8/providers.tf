locals {
  config = data.terraform_remote_state.kubeconfig.outputs.kubeconfig_command
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.2.0"
    }
  }
}

provider "kubernetes" {
    #config_path = "../k3s-myk3_node-50895.yaml"
    config_path = split("=", local.config)[1]
}

provider "helm" {
  kubernetes {
    config_path = split("=", local.config)[1]
  }
}

provider "aws" {
    region = var.aws_region
}