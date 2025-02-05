terraform {
  required_version = "~> 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20, < 6.0"
    }
  }
}

data "aws_caller_identity" "current" {}
