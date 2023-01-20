terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.3"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "ecs-cluster" {
  source                  = "./terraform/ecs-cluster"
  #############################
  #         App config        #
  #############################
  cluster_name            = var.CLUSTER_NAME
  #############################
  #      AWS environment      #
  #############################
  region                  = var.AWS_REGION
}