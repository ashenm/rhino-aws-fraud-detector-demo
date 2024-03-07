terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.1"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "0.71.0"
    }
  }
  required_version = ">= 1.5"
}
