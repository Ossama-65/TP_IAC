terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"  # Remplace par ta région AWS
}

# Clé SSH pour les instances
resource "aws_key_pair" "deployer" {
  key_name   = "deployer_key"
  public_key = file("~/.ssh/id_rsa.pub")  # Assure-toi d'avoir généré une clé SSH
}

# Groupe de sécurité pour les instances
resource "aws_security_group" "web_sg" {
  name_prefix = "web_security_group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

# Instance EC2 pour NGINX
resource "aws_instance" "nginx" {
  ami           = "ami-0c55b159cbfafe1f0"  # Remplace par une AMI compatible dans ta région
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "nginx_server"
  }
}

# Instance EC2 pour PHP-FPM
resource "aws_instance" "php_fpm" {
  ami           = "ami-0c55b159cbfafe1f0"  # Remplace par une AMI compatible dans ta région
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "php_fpm_server"
  }
}

