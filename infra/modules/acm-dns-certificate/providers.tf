terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Provider for us-east-1 (required for ACM certificate validation)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
