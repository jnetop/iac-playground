resource "aws_ecr_repository" "repository" {
  name = var.beanstalk_application_name
}