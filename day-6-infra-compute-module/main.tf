resource "aws_vpc" "project" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "sub" {
    vpc_id = aws_vpc.project.id
    cidr_block = var.subnet_cidr
    tags = {
        Name = var.subnet_name
    }
}

resource "aws_instance" "my-inst" {
    ami = var.instance_ami
    subnet_id = aws_subnet.sub.id
    instance_type = "t3.micro"
    tags = {
        Name = "dev"
    }
}