resource "aws_security_group" "lb_security_group" {
  name        = "lb_security_group"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "lb_security_group_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #0.0.0.0 - 255.255.255.255
  security_group_id = aws_security_group.lb_security_group.id
}

resource "aws_security_group_rule" "lb_security_group_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #0.0.0.0 - 255.255.255.255
  security_group_id = aws_security_group.lb_security_group.id
}