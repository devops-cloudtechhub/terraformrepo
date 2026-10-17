# creating new vpc with custom cidr block and subnets
resource "aws_vpc" "project" {
    cidr_block ="10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }
}
resource "aws_subnet" "pro" {
    vpc_id = aws_vpc.project.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "my-subnet"
    }
}
resource "aws_route_table" "my-rt" {
    vpc_id = aws_vpc.project.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
    }
        tags = {
            Name = "my-route-table"
        }
}
resource "aws_route_table_association" "my-rt-assoc" {
    subnet_id = aws_subnet.pro.id
    route_table_id = aws_route_table.my-rt.id
}
resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.project.id
    tags = {
        Name = "my-igw"
    }
}
resource "aws_eip" "nat-eip" {
    domain = "vpc"
    depends_on = [aws_internet_gateway.my-igw]
}
resource "aws_nat_gateway" "my-nat" {
    allocation_id = aws_eip.nat-eip.id
    subnet_id = aws_subnet.pro.id
    tags = {
        Name = "my-nat"
    }
}
resource "aws_instance" "my-inst" {
    ami ="ami-0c766c2cff1b35ed2"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.pro.id
    vpc_security_group_ids = [aws_security_group.my-sg.id]
    tags = {
        Name = "dev"
    }
lifecycle {
    create_before_destroy = true
    #prevent_destroy = true
    }
}
resource "aws_eip" "instance-eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.my-igw]
}
resource "aws_eip_association" "my-eip-assoc" {
  instance_id   = aws_instance.my-inst.id
  allocation_id = aws_eip.instance-eip.id
    }
resource "aws_security_group" "my-sg" {
    vpc_id = aws_vpc.project.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
# This resource links your existing Elastic IP to your EC2 instance
}

resource "aws_s3_bucket" "my-bucket" {
  bucket = "rags-testbuck"
  #acl    = "private"
  tags = {
    Name        = "MyBucket"
    Environment = "Dev"
  }
}
