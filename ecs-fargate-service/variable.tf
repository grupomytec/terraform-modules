variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = null
}

variable "task_environment" {
  type        = string
  description = "Task environment variables"
  default     = "{}"
}

variable "task_secrets" {
  type        = string
  description = "Task environment secrets"
  default     = "{}"
}

variable "task_health_check_command" {
  type        = string
  description = "Task environment secrets"
}

#variable "task_role" {
#  type        = string
#  description = "Task role"
#}

#variable "task_exec_role" {
#  type        = string
#  description = "Task exec role"
#}

variable "service_security_group" {
  type        = list
  description = "Service network security group"
}

variable "service_subnets" {
  type        = list
  description = "Service network subnets"
}

variable "assign_public_ip" {
  type        = bool
  description = "Assign Public IP"
}

variable "sub_domain" {
  type        = string
  description = "Sub Domain App"
}

variable "service_host_app_port" {
  type = string
  description = "Service Host App Port"
}

variable "task_container_app_port" {
  type = string
  description = "Task Contianer App Port"
}

variable "account_id" {
  type        = number
  description = "Account id  of the task"
}

variable "target_group_port" {
  type        = number
  description = "Target Group Port"
}

variable "target_group_protocol" {
  type        = string
  description = "Target Group Protocol"
}

variable "target_group_vpc" {
  type        = string
  description = "Target Group VPC"
}

variable "target_group_target_type" {
  type        = string
  description = "Target Group Typer"
}


#variable "load_balancer" {
#  type        = string
#  description = "Loadbalancer listener of the task"
#}

variable "region" {
  type        = string
  description = "Region of the task"
}

#variable "load_balancer_target_group" {
#  type        = string
#  description = "Load Balancer Target Group"
#}

variable "load_balancer_listner" {
  type        = string
  description = "Load Balancer Listner"
}

variable "load_balancer_listner_host_header" {
  type        = list
  description = "Load Balancer Host Header"
}


variable "logs_retention" {
  type        = number
  description = "Log retention days used in Tasks"
}

variable "ecr_retention" {
  type        = number
  description = "ECR Image Retention"
}

variable "cpu" {
  type        = number
  description = "CPU used in Tasks"
}

variable "memory" {
  type        = number
  description = "Memory used in Tasks"
}

variable "min_capacity" {
  type        = number
  description = "Min Capacity in Autoscaling"
}

variable "max_capacity" {
  type        = number
  description = "Max Capacity in Autoscaling"
}

variable "metric_type" {
  type        = string
  description = "Metric Type in Autoscaling"
}

variable "target_value" {
  type        = number
  description = "Target Value in Autoscaling"
}

variable "tg-interval" {
  type        = number
  description = "Interval HealthCheck"
}

variable "tg-path" {
  type        = string
  description = "Path HealthCheck"
}

variable "tg-timeout" {
  type        = number
  description = "Timeout HealthCheck"
}

variable "tg-matcher" {
  type        = string
  description = "Matcher HealthCheck"
}

variable "tg-healthy_threshold" {
  type        = number
  description = "Healthy Threshold HealthCheck"
}

variable "tg-unhealthy_threshold" {
  type        = number
  description = "Unhealthy Threshold HealthCheck"
}

variable "cluster_name" {
  type = string
  description = "ECS Cluster"  
}

variable "health_check_grace_period_seconds" {
  type = number
  description = "Health Check Grace Period Seconds"  
}

variable "app_name" {
  type        = string
  description = "Name of Project"
}