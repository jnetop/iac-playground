terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
    profile = "default"
    region = var.aws_region
}

resource "aws_launch_template" "machine" {
    image_id = "ami-03d5c68bab01f3496"
    instance_type = var.instance_type
    key_name = var.key
    tags = {
        Name = "EC2 Autoscaling Group"
    }
    security_group_names = [ var.security_group ]
}

resource "aws_key_pair" "ssh_key" {
    key_name = var.key
    public_key = file("${var.key}.pub")
}

resource "aws_autoscaling_group" "autoscaling_group" {
    availability_zones = [ "${var.aws_region}a", "${var.aws_region}b" ]
    name = var.group_name
    max_size = var.group_max_size
    min_size = var.group_min_size
    target_group_arns = [ aws_lb_target_group.lb_target.arn ]
    launch_template {
      id = aws_launch_template.machine.id
      version = "$Latest"
    }
}

resource "aws_default_subnet" "subnet_1" {
 availability_zone = "${var.aws_region}a"
}

resource "aws_default_subnet" "subnet_2" {
 availability_zone = "${var.aws_region}b"
}

resource "aws_lb" "load_balancer" {
    internal = false
    subnets = [ aws_default_subnet.subnet_1.id, aws_default_subnet.subnet_2.id ]
}

resource "aws_default_vpc" "vpc" {
}

resource "aws_lb_target_group" "lb_target" {
    name = "lb-target"
    port = 8000
    protocol = "HTTP"
    vpc_id = aws_default_vpc.vpc.id
}

resource "aws_lb_listener" "lb_entrance" {
    load_balancer_arn = aws_lb.load_balancer.arn
    port = "8000"
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.lb_target.arn
    }
}

resource "aws_autoscaling_policy" "autoscaling_policy" {
    name = "terraform-autoscaling-policy"
    autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
    }
}