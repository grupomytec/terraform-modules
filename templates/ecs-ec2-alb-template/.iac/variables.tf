############
#    ALB   #
############


variable "VPC" {
  type = string
  description = "ALB VPC ID"
}

variable "SUBNETS" {
  type = list
  description = "ALB Subnets ID"
}

############
#    SG    #
############

variable "SG_INGRESS_FROM_PORT" {
  type = number
  description = "Security Group Ingress From Port"
}

variable "SG_INGRESS_PROTOCOL" {
  type = string
  description = "Security Group Ingress Protocol"
}
variable "SG_INGRESS_TO_PORT" {
  type = number
  description = "Security Group Ingress To Port"
}

variable "SG_INGRESS_CIDR_BLOCKS" {
  type = list
  description = "Security Group Ingress CIDR Blocks"
}

variable "SG_EGRESS_FROM_PORT" {
  type = number
  description = "Security Group Egress From Port"
}

variable "SG_EGRESS_TO_PORT" {
  type = number
  description = "Security Group Egress To Port"
}

variable "SG_EGRESS_PROTOCOL" {
  type = number
  description = "Security Group Egress To Port"
}

variable "SG_EGRESS_CIDR_BLOCKS" {
  type = list
  description = "Security Group Egress CIDR Blocks"
}

############
#    TG    #
############

variable "TG_PORT" {
  type = number
  description = "Target Group Port"
}

variable "TG_PROTOCOL" {
  type = string
  description = "Target Group Port"
}

variable "TG_HEALTH_CHECK_HEALTHY_THRESHOLD" {
  type = number
  description = "Target Group Healthy Threshold"
}

variable "TG_HEALTH_CHECK_PATH" {
  type = string
  description = "Target Check Path"
}

##################
#   LB LISTNER   #
##################

variable "ALB_PORT" {
  type = number
  description = "LB Listner Port"
}

variable "ALB_PROTOCOL" {
  type = string
  description = "LB Listner Protocol"
}

variable "ALB_DEFAULT_ACTION_TYPE" {
  type = string
  description = "LB Listner Default Actions Type"
}

############
#    ECS   #
############
variable "CLUSTER_NAME" {
  type = string
}

variable "APP_NAME" {
  type = string
}