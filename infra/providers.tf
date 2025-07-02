terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.58.0"
    }
  }

  backend "s3" {
    bucket = "triggered-infrastructure-state"
    key    = "provisioning-state"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}
