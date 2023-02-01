############
#    ALB   #
############

variable "vpc" {
  type = string
  description = "ALB VPC ID"
}

variable "subnets" {
  type = list
  description = "ALB Subnets ID"
}

############
#    SG    #
############

variable "sg_ingress_from_port" {
  type = number
  description = "Security Group Ingress From Port"
}

variable "sg_ingress_protocol" {
  type = string
  description = "Security Group Ingress Protocol"
}

variable "sg_ingress_to_port" {
  type = number
  description = "Security Group Ingress To Port"
}

variable "sg_ingress_cidr_blocks" {
  type = list
  description = "Security Group Ingress CIDR Blocks"
}

variable "sg_egress_from_port" {
  type = number
  description = "Security Group Egress From Port"
}

variable "sg_egress_to_port" {
  type = number
  description = "Security Group Egress To Port"
}

variable "sg_egress_protocol" {
  type = number
  description = "Security Group Egress To Port"
}

variable "sg_egress_cidr_blocks" {
  type = list
  description = "Security Group Egress CIDR Blocks"
}

############
#    TG    #
############

variable "tg_port" {
  type = number
  description = "Target Group Port"
}

variable "tg_protocol" {
  type = string
  description = "Target Group Port"
}

variable "tg_health_check_healthy_threshold" {
  type = number
  description = "Target Group Healthy Threshold"
}

variable "tg_health_check_path" {
  type = string
  description = "Target Check Path"
}

##################
#   LB LISTNER   #
##################

variable "alb_port" {
  type = number
  description = "LB Listner Port"
}

variable "alb_protocol" {
  type = string
  description = "LB Listner Protocol"
}

variable "alb_default_action_type" {
  type = string
  description = "LB Listner Default Actions Type"
}

############
#    ECS   #
############

variable "cluster_name" {
  type = string
  description = "ECS Cluster"
}

variable "app_name" {
  type = string
  description = "ECS Cluster"
}
