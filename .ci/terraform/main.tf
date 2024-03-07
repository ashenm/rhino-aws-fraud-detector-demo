terraform {
  backend "s3" {
    bucket         = "rhino-terraform-states"
    dynamodb_table = "BITBUCKET-RUNNER-TERRAFORM-STATE-LOCKS"
    region         = "ap-southeast-1"
    key            = "rhino-aws-fraud-detector-demo.tfstate"
  }
}

locals {
  name_prefix = "${var.environment}-${var.project_name}"

  common_tags = {
    Environment = upper(var.environment)
    Project     = upper(var.project_name)
  }
}
