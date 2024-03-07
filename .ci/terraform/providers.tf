provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

provider "awscc" {
  region = var.aws_region
}
