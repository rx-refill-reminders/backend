terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.default, aws.us_east_1]
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
