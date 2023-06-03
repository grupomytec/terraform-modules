terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.3"
    }
  }
  backend "s3" {}
}

module "ecs-ec2-service-module" {
  source                      = "../../ecs-ec2-service"
  app_name                    = var.APP_NAME
  cluster_name                = var.CLUSTER_NAME
  #############################
  #         App config        #
  #############################
  sub_domain                  = var.SUB_DOMAIN
  app_port                    = var.APP_PORT
  cpu                         = var.CPU
  memory                      = var.MEMORY
  metric_type                 = var.METRIC_TYPE
  min_capacity                = var.MIN_CAPACITY
  max_capacity                = var.MAX_CAPACITY
  target_value                = var.TARGET_VALUE
  tg-interval                 = var.TG_INTERVAL
  tg-timeout                  = var.TG_TIMEOUT
  tg-path	                    = var.TG_PATH
  tg-matcher                  = var.TG_MATCHER
  tg-healthy_threshold        = var.TG_HEALTHY_THRESHOLD
  tg-unhealthy_threshold      = var.TG_UNHEALTHY_THRESHOLD
  task_secrets                = var.TASK_SECRETS
  task_environment            = var.TASK_ENVIRONMENT
  #task_role                   = var.TASK_ROLE
  #task_exec_role              = var.TASK_EXEC_ROLE
  #############################
  #      AWS environment      #
  #############################
  account_id                  = var.AWS_ACCOUNT_ID
  region                      = var.AWS_REGION
  # load_balancer               = var.LOAD_BALANCER
  load_balancer_target_group  = var.LOAD_BALANCER_TARGET_GROUP
  load_balancer_listner       = var.LOAD_BALANCER_LISTNER
  logs_retention              = var.LOGS_RETENTION
  ecr_retention               = var.ECR_RETENTION
  # tags                        = var.TAGS
}   
