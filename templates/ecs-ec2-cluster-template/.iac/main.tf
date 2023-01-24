terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.3"
    }
  }
  backend "s3" {}
}

module "ecs-cluster" {
  source                  = "../../../ecs-ec2-cluster"
  #############################
  #         App config        #
  #############################
  cluster_name            = var.CLUSTER_NAME
  #############################
  #      AWS environment      #
  #############################
  region                  = var.AWS_REGION
  capacity_provider       = var.CAPACITY_PROVIDER
  weight                  = var.WEIGHT
  base                    = var.BASE
  user_data               = var.USER_DATA
}
