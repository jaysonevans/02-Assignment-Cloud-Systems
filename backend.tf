terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "je-tf"
    key    = "p3/tfstate.tf"
  }
}