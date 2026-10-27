resource "aws_instance" "my-inst" {
    ami ="ami-0c766c2cff1b35ed2"
    region = "us-west-2"
    instance_type = "t3.micro"
    subnet_id = "subnet-068ddd1b972e87106"
    tags = {
        Name = "dev"
    }
#lifecycle {
#     ignore_changes = [tags]
#   }
lifecycle {
    create_before_destroy = true
}
#lifecycle {
#    prevent_destroy = true
 #}
}
