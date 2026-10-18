variable "vpc_cidr" {
    description = "CIDR block for the vpc"
    type = string
}

variable "vpc_name" {
    description = "Name for the VPC"
    type = string
}

variable "subnet_cidr" {
    description = "CIDR block for the subnet"
    type = string
}

variable "subnet_name" {
    description = "Name for the subnet"
    type = string
}

variable "region" {
    description = "AWS region"
    type = string
}

variable "instance_ami" {
    description = "AMI ID for the instance"
    type = string
}

#variable "instance_name" {
#    description = "Name for the instance"
#    type = string
#}