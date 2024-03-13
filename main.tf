# main.tf
# Jayson Evans
# March 12, 2024
# Orchestrate modules

module "vpc" {
  source = "./vpc"
}

module "security-group" {
  source = "./security-group"
  vpc_id = module.vpc.VPC-MARK-I.id
}

module "ec2" {
  source = "./ec2"
}