resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "dev-vpc"
    }
}
resource "aws_key_pair" "my-key" {
    key_name = "my-laptop-key"
    public_key = file("C:/Users/ragha/.ssh/id_ed25519.pub")
}

resource "aws_subnet" "sub" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-2a"
    map_public_ip_on_launch = true

    tags = {
        Name = "dev-subnet"
    }
}
resource "aws_security_group" "my-sg" {
    vpc_id = aws_vpc.main.id
    name = "dev-sg"
    ingress {
        #Allow ssh from anywhere
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
    egress {
        #Allow all outbound traffic
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "dev-igw"
    }
}
resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}
resource "aws_route_table_association" "rta" {
    subnet_id = aws_subnet.sub.id
    route_table_id = aws_route_table.rt.id
}
resource "aws_instance" "my-instance" {
    ami = "ami-0829b74b2a8c619b7"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.sub.id
    vpc_security_group_ids = [aws_security_group.my-sg.id]
    key_name = aws_key_pair.my-key.key_name
    associate_public_ip_address = true
    tags = {
        Name = "dev-instance"
    }

}
#  connection {
#     type        = "ssh"
#     user        = "ec2-user"                          # ✅ Correct for Ubuntu AMIs
#     private_key = file("C:/Users/ragha/.ssh/id_ed25519") # Path to private key
#     host        = self.public_ip  #or we can use aws_instance.server.public_ip
#     timeout     = "6m"
#   }

#   provisioner "file" {
#     source      = "file10"
#     destination = "/home/ec2-user/file10" #destination path on the remote instance copy the file10 from local to remote instance with the name file10
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "touch /home/ec2-user/file200",
#       "echo 'hello from multicloud devops nareshit' >> /home/ec2-user/file200"
#     ]
#   }
#    provisioner "local-exec" {
#     command = "touch file500" 
#    }
# }
 
resource "null_resource" "run_script" {

    connection {
      type       = "ssh"
      host        = aws_instance.my-instance.public_ip
      user        = "ec2-user"
      private_key = file("C:/Users/ragha/.ssh/id_ed25519")
    }
     provisioner "file" {
    source      = "dev.sh"
    destination = "/home/ec2-user/dev.sh" #destination path on the remote instance copy the file10 from local to remote instance with the name file10
     }
    provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",                  # Update packages (Amazon Linux 2023 uses dnf)
      "sudo dnf install nginx -y",           # Install Nginx
      "sudo systemctl enable nginx",         # Enable Nginx to start on boot
      "sudo systemctl start nginx",          # Start Nginx immediately
      "chmod +x /home/ec2-user/dev.sh",
      "sudo /home/ec2-user/dev.sh"
    ]
    }
#     triggers = {
#     always_run = "${timestamp()}" # This will ensure the provisioner runs every time you apply, as the timestamp will always change.
#   }
    triggers = {
    script_hash = filemd5("dev.sh") # Rerun only if script changes
    }
}

