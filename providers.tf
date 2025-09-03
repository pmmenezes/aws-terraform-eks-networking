terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.11"
    }
  }
}

provider "aws" {
  region = var.region
  # https://developer.hashicorp.com/terraform/tutorials/aws/aws-default-tags?in=terraform%2Faws
  default_tags {
    tags = var.default_tags

  }
}


