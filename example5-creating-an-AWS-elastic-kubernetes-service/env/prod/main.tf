module "prod" {
    source = "../../infra"

    env_name = "production"
}

# output "eks_DNS" {
#   value = module.prod.DNS
# }