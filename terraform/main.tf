
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.68.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
# Security Group to allow SSH, HTTP, and other ports
resource "aws_security_group" "sg_financeme01" {
  name        = "sg_financeme01"
  description = "Allow SSH, HTTP, and range 8080-8099"

  # Allow SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Allow a range of ports (8080-8099)
  ingress {
    from_port   = 8080
    to_port     = 8099
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Create EC2 Instance
resource "aws_instance" "FinanceMe" {
  ami             = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"
  key_name = "ansible_key"
  vpc_security_group_ids = [aws_security_group.sg_financeme01.id]
  tags = {
    Name = "FinanceMe"
  }
}
output "testerver_publicip" {
  value = aws_instance.FinanceMe.public_ip
}
