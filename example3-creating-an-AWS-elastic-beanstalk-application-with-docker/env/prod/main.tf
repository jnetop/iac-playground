module "production" {
  source = "../../Infra"

  beanstalk_application_name = "production"
  beanstalk_application_description = "production-application"
  beanstalk_application_environment = "production-environment"
  machine = "t2.micro"
  machine_maxsize = 5
}