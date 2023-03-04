############
#    LT    #
############

variable "image_id" {
  type = string
  description = "Launch Template Image Id"
}

variable "instance_type" {
  type = string
  description = "Launch Template Instance Type"
}

#variable "user_data" {
#  type = string
#  description = "Launch Template User Data"
#}


############
#    ASG   #
############

variable "availability_zones" {
  type = string
  description = "Autoscaling Group Avaliability Zones"
}

variable "default_cooldown" {
  type = number
  description = "Autoscaling Group Default Cooldown"
}

variable "desired_capacity" {
  type = number
  description = "Autoscaling Group Desired Capacity"
}

variable "max_size" {
  type = number
  description = "Autoscaling Group Max Size"
}

variable "min_size" {
  type = number
  description = "Autoscaling Group Min Size"
}


############
#    CPS   #
############

variable "maximum_scaling_step_size" {
  type = number
  description = "Capacity Provider Maximum Scaling"
}

variable "minimum_scaling_step_size" {
  type = number
  description = "Capacity Provider Minimum Scaling"
}

variable "target_capacity" {
  type = number
  description = "Capacity Provider Target Capacity"
}

variable "weight" {
  type = number
  description = "Capacity Provider Weight"
}

variable "base" {
  type = number
  description = "Capacity Provider Base"
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
