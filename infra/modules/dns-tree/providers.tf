terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27.0"
    }
  }

  required_version = "~> 1.0"
}

# Provider for us-east-1 (required for ACM certificate validation)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
