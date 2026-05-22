# Shared Terragrunt configuration for all stacks and units.

locals {
  stack = yamldecode(file(find_in_parent_folders("stack.yml")))
}

remote_state {
  backend = "s3"

  config = {
    bucket       = local.stack["states-bucket"]
    key          = "${path_relative_to_include()}/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region = "us-east-1"
}
EOF
}
