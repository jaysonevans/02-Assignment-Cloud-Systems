# main.tf
# Jayson Evans
# March 12, 2024
# Orchestrate modules

module "vpc" {
  source  = "./vpc"
  cidrs   = ["192.168.0.0/18", "192.168.64.0/18", "192.168.128.0/18", "192.168.192.0/18"]
  counter = 4
  azs     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}

module "security-group" {
  source = "./security-group"
  vpc_id = module.vpc.VPC-MARK-I.id
}

module "ec2" {
  source      = "./ec2"
  subnets     = module.vpc.subnets-in-vpc-ids
  counter     = 4
  secgrp-name = module.security-group.SECGRP-MARK-I.name
}