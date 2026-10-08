terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "cloudops_forge_sg" {
  name        = "cloudops-forge-sg"
  description = "Allow SSH from my IP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
      }
  ingress {
    description = "Flask app"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.cloudops_forge.public_ip
}

resource "aws_instance" "cloudops_forge" {
  ami                         = "ami-0a59fb4395466ed05"
  instance_type                = var.instance_type
  key_name                     = "cloudops-forge-key"
  subnet_id                    = "subnet-0c1802ad1c17f8622"
  associate_public_ip_address  = true
  vpc_security_group_ids       = [aws_security_group.cloudops_forge_sg.id]
    user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              docker run -d -p 5001:5001 ghcr.io/kris9887/cloudops-forge:latest
              EOF

  tags = {
    Name = "cloudops-forge-ec2"
  }
}
