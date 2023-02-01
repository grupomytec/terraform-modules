terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.3"
    }
  }
  backend "s3" {}
}

module "ecs-ec2-alb" {
  source                  = "../../../ecs-ec2-alb"
  #############################
  #      AWS environment      #
  #############################
  ############
  #    ECS   #
  ############
  cluster_name                      = var.CLUSTER_NAME
  app_name                          = var.APP_NAME
  ############
  #    SG    #
  ############
  vpc                               = var.VPC
  subnets                           = var.SUBNETS 
  sg_ingress_from_port              = var.SG_INGRESS_FROM_PORT
  sg_ingress_protocol               = var.SG_INGRESS_PROTOCOL
  sg_ingress_to_port                = var.SG_INGRESS_TO_PORT
  sg_ingress_cidr_blocks            = var.SG_INGRESS_CIDR_BLOCKS
  sg_egress_from_port               = var.SG_EGRESS_FROM_PORT
  sg_egress_to_port                 = var.SG_EGRESS_TO_PORT
  sg_egress_protocol                = var.SG_EGRESS_PROTOCOL
  sg_egress_cidr_blocks             = var.SG_EGRESS_CIDR_BLOCKS
  ############
  #    TG    #
  ############  
  tg_port                           = var.TG_PORT
  tg_protocol                       = var.TG_PROTOCOL
  tg_health_check_healthy_threshold = var.TG_HEALTH_CHECK_HEALTHY_THRESHOLD
  tg_health_check_path              = var.TG_HEALTH_CHECK_PATH
  ##################
  #   LB LISTNER   #
  ##################
  alb_port                           = var.ALB_PORT
  alb_protocol                       = var.ALB_PROTOCOL
  alb_default_action_type            = var.ALB_DEFAULT_ACTION_TYPE
}
