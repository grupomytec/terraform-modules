variable "AWS_REGION" {
  type = string
}
variable "AWS_ACCOUNT_ID" {
  type = string
}


variable "TARGET_GROUP_PORT" {
  type        = number
  description = "Account id  of the task"
}

variable "TARGET_GROUP_PROTOCOL" {
  type        = string
  description = "Account id  of the task"
}

variable "TARGET_GROUP_VPC" {
  type        = string
  description = "Account id  of the task"
}

variable "TARGET_GROUP_TARGET_TYPE" {
  type        = string
  description = "Account id  of the task"
}

variable "CLUSTER_NAME" {
  type = string
}

variable "SUB_DOMAIN" {
  type = string
  default = ""
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
  default = 5
}

variable "TG_UNHEALTHY_THRESHOLD" {
  type = string
  default = 2
}

#variable "LOAD_BALANCER" {
#  type = string
#}

variable "LOGS_RETENTION" {
  type = string
  default = 1
}

variable "ECR_RETENTION" {
  type = string
}

#variable "TAGS" {
#  type = map(string)
#  default = ""
#}

variable "TASK_ENVIRONMENT" {
  type = string
}
variable "TASK_SECRETS" {
  type = string
}
#variable "TASK_ROLE" {
#  type = string
#}
#variable "TASK_EXEC_ROLE" {
#  type = string
#}

variable "APP_NAME" {
  type = string
}

#variable "LOAD_BALANCER_TARGET_GROUP" {
#  type = string
#}

variable "LOAD_BALANCER_LISTNER" {
  type = string
}

variable "SERVICE_SECURITY_GROUP" {
  type = list
}

variable "SERVICE_SUBNETS" {
  type = list
}

variable "ASSIGN_PUBLIC_IP" {
  type        = bool
}