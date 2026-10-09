resource "aws_vpc" "test" {
  cidr_block = "192.168.1.0/24"
  tags = {
    Name = "test-vpc"
  }
}