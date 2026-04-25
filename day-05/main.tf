data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_key_pair" "devops_key" {
    key_name = "devops-key"
    public_key = file("~/.ssh/devops/devops-key.pub")
}

resource "aws_security_group" "devops_sg" {
    name = "devops-sg"
    description = "Allow SSH and HTTP"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    ingress {
        from_port = 80
        to_port = 80
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

resource "aws_instance" "devops_server" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t3.micro"
    key_name = aws_key_pair.devops_key.key_name
    vpc_security_group_ids = [aws_security_group.devops_sg.id]

    user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install nginx -y
    systemctl start nginx
    systemctl enable nginx
    EOF

    tags = {
        Name = "devops-server-day05"
    } 

}

