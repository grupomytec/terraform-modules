############
#    LT    #
############

variable "IMAGE_ID" {
  type = string
  description = "User Data"
  default = "ami-07da26e39622a03dc"
}

variable "INSTANCE_TYPE" {
  type = string
  description = "ECS Cluster"
  default = "t2.micro"
}

variable "USER_DATA" {
  type = string
  description = "ECS Cluster"
}

############
#    ASG   #
############

variable "AVAILABILITY_ZONES" {
  type = list
  description = "Autoscaling Group Avaliability Zones"
  default = ["us-east-1a", "us-east-1b"]
}

variable "DEFAULT_COOLDOWN" {
  type = number
  description = "Autoscaling Group Default Cooldown"
  default = 600
}

variable "DESIRED_CAPACITY" {
  type = number
  description = "Autoscaling Group Desired Capacity"
  default = 1
}

variable "MAX_SIZE" {
  type = number
  description = "Autoscaling Group Max Size"
  default = 1
}

variable "MIN_SIZE" {
  type = number
  description = "Autoscaling Group Min Size"
  default = 1
}

############
#    CPS   #
############

variable "MAXIMUM_SCALING_STEP_SIZE" {
  type = number
  description = "Capacity Provider Maximum Scaling"
  default = 2
}

variable "MINIMUM_SCALING_STEP_SIZE" {
  type = number
  description = "Capacity Provider Minimum Scaling"
  default = 1
}

variable "TARGET_CAPACITY" {
  type = number
  description = "Capacity Provider Target Capacity"
  default = 3
}

variable "BASE" {
  type = number
  description = "Capacity Provider Base"
  default = 1
}

variable "WEIGHT" {
  type = number
  description = "Capacity Provider Weight"
  default = 100
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