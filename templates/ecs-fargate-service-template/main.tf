terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.3"
    }
  }
  backend "s3" {}
}

module "ecs-fargate-service-module" {
  source                      = "../../ecs-fargate-service"
  app_name                    = var.APP_NAME
  cluster_name                = var.CLUSTER_NAME
  health_check_grace_period_seconds = var.HEALTH_CHECK_GRACE_PERIOD_SECONDS
  #############################
  #         App config        #
  #############################
  sub_domain                  = var.SUB_DOMAIN
  #app_port                    = var.APP_PORT
  service_host_app_port       = var.SERVICE_HOST_APP_PORT
  task_container_app_port     = var.TASK_CONTAINER_APP_PORT
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
  task_health_check_command   = var.TASK_HEALTH_CHECK_COMMAND
  task_environment            = var.TASK_ENVIRONMENT
  service_security_group      = var.SERVICE_SECURITY_GROUP 
  service_subnets             = var.SERVICE_SUBNETS
  target_group_port           = var.TARGET_GROUP_PORT
  target_group_protocol       = var.TARGET_GROUP_PROTOCOL
  target_group_vpc            = var.TARGET_GROUP_VPC
  target_group_target_type    = var.TARGET_GROUP_TARGET_TYPE
  assign_public_ip            = var.ASSIGN_PUBLIC_IP
  #############################
  #      AWS environment      #
  #############################
  account_id                        = var.AWS_ACCOUNT_ID
  region                            = var.AWS_REGION
  #load_balancer                    = var.LOAD_BALANCER
  #load_balancer_target_group       = var.LOAD_BALANCER_TARGET_GROUP
  load_balancer_listner             = var.LOAD_BALANCER_LISTNER
  load_balancer_listner_host_header = var.LOAD_BALANCER_LISTNER_HOST_HEADER
  logs_retention                    = var.LOGS_RETENTION
  ecr_retention                     = var.ECR_RETENTION
  # tags                            = var.TAGS
}   