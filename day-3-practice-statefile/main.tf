resource "aws_instance" "name" {
    ami = "ami-0c766c2cff1b35ed2"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.name.id
    tags = {
        Name = "my-instance"
    }
}
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }
}
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "my-subnet"
    }
}