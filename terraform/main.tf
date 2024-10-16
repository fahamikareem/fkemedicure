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

# Security Group to allow SSH, HTTP, K8S, and other ports
resource "aws_security_group" "sg_fkemedicure02" {
  name        = "sg_fkemedicure02"
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

    # Allow K8s API (port 6443)
  ingress {
    from_port   = 6443
    to_port     = 6443
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
# Create EC2 Instance- k8s Master
resource "aws_instance" "fkemedicure_k8s_master" {
  ami             = "ami-005fc0f236362e99f"
  instance_type = "t2.micro"
  key_name = "ansible_key"
  vpc_security_group_ids = [aws_security_group.sg_fkemedicure02.id]
  tags = {
    Name = "fkemedicure_k8s_master"
  }
}
# Create EC2 Instance- k8s worker01
resource "aws_instance" "fkemedicure_k8s_worker01" {
  ami             = "ami-005fc0f236362e99f"
  instance_type = "t2.micro"
  key_name = "ansible_key"
  vpc_security_group_ids = [aws_security_group.sg_fkemedicure02.id]
  tags = {
    Name = "fkemedicure_k8s_worker01"
  }
}
# Create EC2 Instance- k8s worker02
resource "aws_instance" "fkemedicure_k8s_worker02" {
  ami             = "ami-005fc0f236362e99f"
  instance_type = "t2.micro"
  key_name = "ansible_key"
  vpc_security_group_ids = [aws_security_group.sg_fkemedicure02.id]
  tags = {
    Name = "fkemedicure_k8s_worker02"
  }
}

#output
output "fkemedicure_k8s_master_publicip" {
  value = aws_instance.fkemedicure_k8s_master.public_ip
}
output "fkemedicure_k8s_worker01_publicip" {
  value = aws_instance.fkemedicure_k8s_worker01.public_ip
}
output "fkemedicure_k8s_worker02_publicip" {
  value = aws_instance.fkemedicure_k8s_worker02.public_ip
}
