module "aws_prod" {
    source = "../../infra"
    instance_type = "t2.micro"
    aws_region = "us-west-2"
    key = "iac-playground-example2-prod"
    security_group = "production"
    group_min_size = 1
    group_max_size = 10
    group_name = "prod"
}