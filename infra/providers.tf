terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.58.0"
    }
  }

  backend "s3" {
    bucket = local.state_bucket
    key    = local.state_key
    region = local.region
  }
}

provider "aws" {
  region = local.region
}
