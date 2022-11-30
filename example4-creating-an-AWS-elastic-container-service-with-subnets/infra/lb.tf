resource "aws_lb" "lb" {
  name               = "ECS-DotNet"
  security_groups    = [aws_security_group.lb_security_group.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target.arn
  }
}

resource "aws_lb_target_group" "target" {
  name        = "ECS-DotNet"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
}

output "DNS" {
  value = aws_lb.lb.dns_name
}