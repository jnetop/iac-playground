terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-017fecd1353bcc96e"
  instance_type = "t2.micro"
  key_name = "iac-playground-example1"
  vpc_security_group_ids = [aws_security_group.total_access.id]
  tags = {
    Name = "CreatingAVirtualMachineExample"
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name = "iac-playground-example1"
  public_key = file("iac-playground-example1.pub")
}

resource "aws_security_group" "total_access" {
  name = "total_access"
  description = "A permissive security group"
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
    from_port = 0
    to_port = 0
    protocol = -1
  }
  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
    from_port = 0
    to_port = 0
    protocol = -1
  }
  tags = {
    name = "total_access"
  }
}