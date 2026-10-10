variable "vpc_cidr" {
description = "The CIDR block for the VPC"
default = ""
  type = string

}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  default = ""
  type = string

}