resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "test-vpc"
    }
}
resource "aws_subnet" "vpc-sub" {
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-2a"
    map_public_ip_on_launch = true
    tags = {
        Name = "test-sub"
    }
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my-vpc.id
    tags = {
      Name =  "my-igw"
    }
}
resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.my-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}
resource "aws_route_table_association" "rt_asso" {
    subnet_id = aws_subnet.vpc-sub.id
    route_table_id = aws_route_table.rt.id
}
resource "aws_key_pair" "my-key" {
    key_name = "my-laptop-key"
    public_key = file("C:/Users/ragha/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "mysg" {
    vpc_id = aws_vpc.my-vpc.id
    name = "test-sg"
    tags = {
        Name = "cus-sg"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_instance" "ec2" {
    ami = "ami-0e30f57315735eae4"
    instance_type = "t2.medium"
    subnet_id = aws_subnet.vpc-sub.id
    vpc_security_group_ids = [aws_security_group.mysg.id]
    key_name = aws_key_pair.my-key.key_name
    associate_public_ip_address = true
    tags = {
        Name = "Jenkins"
    }
}

resource "null_resource" "run_script" {
    connection {
        host = aws_instance.ec2.public_ip
        user = "ec2-user"
        private_key = file("C:/Users/ragha/.ssh/id_ed25519")
    }
    provisioner "remote-exec" {
        inline = [
            "sudo dnf install git -y",
            "sudo dnf update -y",
            # Install Java 21
            "sudo dnf install java-21-amazon-corretto-devel -y",

            # Verify Java
            #java -version
        
            "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",

            # Import key
            "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key",

            # Install Jenkins
            "sudo dnf install jenkins -y",

            # Enable + start
            "sudo systemctl enable jenkins",
            "sudo systemctl start jenkins",
            # terraform install
            "sudo yum install -y yum-utils",
            "sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo",
            "sudo yum -y install terraform"
        ]

    }

}