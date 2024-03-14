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
  vpc_id = module.vpc.vpc.id
}

module "ec2" {
  source     = "./ec2"
  counter    = 4
  vpc-id     = module.vpc.vpc.id
  subnet-ids = module.vpc.subnet-ids
  secgrp-id  = module.security-group.secgrp-mark-i.id
}