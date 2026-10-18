# module-calling/main.tf

module "compute" {
    source = "../day-6-infra-compute-module"

    vpc_cidr = "10.0.0.0/16"
    vpc_name = "my-vpc"
    subnet_cidr = "10.0.1.0/24"
    subnet_name = "my-subnet"
    region = "us-west-2"
    instance_ami = "ami-0803a33fd43db1fbf"
    #instance_name = "my-instance"
}