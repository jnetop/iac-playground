module "prod" {
    source = "../../infra"

    env_name = "production"
    ecr_repository_name = "production"
}

output "lb_DNS" {
  value = module.prod.DNS
}