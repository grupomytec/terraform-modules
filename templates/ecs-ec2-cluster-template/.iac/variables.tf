variable "AWS_REGION" {
  type = string
  default = "us-east-1"
}

variable "BUCKET_NAME" {
  type = string
  default = "us-east-1"
}

variable "CLUSTER_NAME" {
  type = string
}

variable "USER_DATA" {
  type = string
  description = "User Data"
}

variable "CAPACITY_PROVIDER" {
  type = string
  description = "Capacity Provider"
}

variable "WEIGHT" {
  type = string
  description = "Weight"
}

variable "BASE" {
  type = string
  description = "Base"
}
