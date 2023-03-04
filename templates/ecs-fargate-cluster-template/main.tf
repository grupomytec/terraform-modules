terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.3"
    }
  }
  backend "s3" {}
}

module "ecs-ec2-cluster" {
  source                  = "../../ecs-fargate-cluster"
  #############################
  #      AWS environment      #
  #############################
  ############
  #    LT    #
  ############
  image_id                  = var.IMAGE_ID
  instance_type             = var.INSTANCE_TYPE
  #user_data                 = var.USER_DATA
  ############
  #    ASG   #
  ############
  availability_zones        = var.AVAILABILITY_ZONES             
  default_cooldown          = var.DEFAULT_COOLDOWN           
  desired_capacity          = var.DESIRED_CAPACITY           
  max_size                  = var.MAX_SIZE   
  min_size                  = var.MIN_SIZE   
  ############
  #    CPS   #
  ############
  maximum_scaling_step_size =  var.MAXIMUM_SCALING_STEP_SIZE
  minimum_scaling_step_size =  var.MINIMUM_SCALING_STEP_SIZE
  target_capacity           =  var.TARGET_CAPACITY
  weight                    =  var.WEIGHT
  base                      =  var.BASE
  ############
  #    ECS   #
  ############
  cluster_name              = var.CLUSTER_NAME
  app_name                  = var.APP_NAME
}
