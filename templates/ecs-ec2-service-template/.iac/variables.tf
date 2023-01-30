variable "AWS_REGION" {
  type = string
}
variable "AWS_ACCOUNT_ID" {
  type = string
}

variable "CLUSTER_NAME" {
  type = string
}

variable "SUB_DOMAIN" {
  type = string
}

variable "APP_PORT" {
  type = string
}

variable "CPU" {
  type = string
}

variable "MEMORY" {
  type = string
}

variable "METRIC_TYPE" {
  type = string
}

variable "MIN_CAPACITY" {
  type = string
}


variable "MAX_CAPACITY" {
  type = string
}

variable "TARGET_VALUE" {
  type = string
}

variable "TG_INTERVAL" {
  type = string
}

variable "TG_TIMEOUT" {
  type = string
}

variable "TG_PATH" {
  type = string
}

variable "TG_MATCHER" {
  type = string
}

variable "TG_HEALTHY_THRESHOLD" {
  type = string
}

variable "TG_UNHEALTHY_THRESHOLD" {
  type = string
}

variable "LOAD_BALANCER" {
  type = string
}

variable "VPC" {
  type = string
}

variable "LOGS_RETENTION" {
  type = string
}

variable "ECR_RETENTION" {
  type = string
}

variable "TAGS" {
  type = map(string)
}

variable "TASK_ENVIRONMENT" {
  type = string
}
variable "TASK_SECRETS" {
  type = string
}
variable "TASK_ROLE" {
  type = string
}
variable "TASK_EXEC_ROLE" {
  type = string
}

variable "APP_NAME" {
  type = string
}