resource "aws_vpc" "test_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "test-vpc"
    }
}

resource "aws_subnet" "test_subnet" {
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = var.subnet_cidr
    tags = {
        Name = "test-subnet"
    }

}

# ==========================================
# 2. OLD VPC AND SUBNET (Restoring Them)
# ==========================================
resource "aws_vpc" "prod" {
    cidr_block = "10.0.0.0/16"  # The original CIDR block you had
    tags = {
        Name = "prod-vpc"
    }
}

resource "aws_subnet" "prod-subnet" {
    vpc_id     = aws_vpc.prod.id
    cidr_block = "10.0.1.0/24"  # The original CIDR block you had
    tags = {
        Name = "prod-subnet"
    }
}