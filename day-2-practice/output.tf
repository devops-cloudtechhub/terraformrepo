output "vpc_ids" {
  value = {
   "prod-vpc" = aws_vpc.prod.id
   "test-vpc" = aws_vpc.test_vpc.id
  }
}

output "subnet_ids" {
  value = {
    "prod-subnet" = aws_subnet.prod-subnet.id
    "test-subnet" = aws_subnet.test_subnet.id
  }
}

output "vpc_cidr" {
  value = {
    "prod-vpc-cidr" = aws_vpc.prod.cidr_block
    "test-vpc-cidr" = aws_vpc.test_vpc.cidr_block
  }
}

output "subnet_cidr" {
  value = {
    "prod-subnet-cidr" = aws_subnet.prod-subnet.cidr_block
    "test-subnet-cidr" = aws_subnet.test_subnet.cidr_block
  }
}

output "vpc_name" {
  value = {
    "prod-vpc-name" = aws_vpc.prod.tags["Name"]
    "test-vpc-name"  = aws_vpc.test_vpc.tags["Name"]
  }
}

output "subnet_name" {
  value = {
    "prod-subnet-name"  = aws_subnet.prod-subnet.tags["Name"]
    "test-subnet-name"  = aws_subnet.test_subnet.tags["Name"]
  }
}

