variable "region" {
  type        = string
  description = "Region of the task"
}

variable "cluster_name" {
  type = string
  description = "ECS Cluster"
}

variable "user_data" {
  type = string
  description = "ECS Cluster"
}

variable "capacity_provider" {
  type = string
  description = "Capacity Provider"
}

variable "weight" {
  type = string
  description = "Weight"
}

variable "base" {
  type = string
  description = "Base"
}
