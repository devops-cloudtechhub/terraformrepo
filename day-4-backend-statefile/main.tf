resource "aws_instance" "my-instance" {
    ami = "ami-0ed59cbb87dfa8dba"
    instance_type = "t3.micro"
    tags = {
        Name = "preprod-instance"
    }
}