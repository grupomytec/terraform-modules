variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = null
}

variable "task_environment" {
  type        = list(any)
  description = "Task environment variables"
  default     = null
}

variable "task_secrets" {
  type        = list(any)
  description = "Task environment secrets"
  default     = null
}

variable "task_role" {
  type        = list(any)
  description = "Task role"
  default     = null
}
variable "task_exec_role" {
  type        = list(any)
  description = "Task exec role"
  default     = null
}


variable "project" {
  type        = string
  description = "Name of Project"
}

variable "sub_domain" {
  type        = string
  description = "Sub Domain App"
}

variable "app_port" {
  type        = number
  description = "Port Container"
}

variable "accountid" {
  type        = number
  description = "Account id  of the task"
}

variable "loadbalancer" {
  type        = string
  description = "Loadbalancer listener of the task"
}


variable "region" {
  type        = string
  description = "Region of the task"
}

variable "vpc" {
  type        = string
  description = "VPC ID used in Tasks"
}


variable "logsretention" {
  type        = number
  description = "Log retention days used in Tasks"
}

variable "ecrretention" {
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