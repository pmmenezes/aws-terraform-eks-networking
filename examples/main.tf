
module "network" {
  source = "../"

  project_name = "teste"
  region       = "us-east-1"
  vpc_cidr     = "10.0.0.0/16"
}