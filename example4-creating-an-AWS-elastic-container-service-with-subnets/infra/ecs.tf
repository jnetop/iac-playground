module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name       = var.env_name

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 1
      }
    }
  }
}

resource "aws_ecs_task_definition" "DotNet-Webapp" {
  family                   = "DotNet-Webapp"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_role.arn
  container_definitions = jsonencode(
    [
      {
        "name"      = "production"
        "image"     = "265776556430.dkr.ecr.us-west-2.amazonaws.com/production:V1"
        "cpu"       = 256
        "memory"    = 512
        "essential" = true
        "portMappings" = [
          {
            "containerPort" = 80
            "hostPort"      = 80
          }
        ]
      }
    ]
  )
}

resource "aws_ecs_service" "DotNet-Webapp" {
  name            = "DotNet-Webapp"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.DotNet-Webapp.arn
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.target.arn
    container_name   = "production"
    container_port   = 80
  }

  network_configuration {
      subnets = module.vpc.private_subnets
      security_groups = [aws_security_group.private_subnets_security_group.id]
  }
}