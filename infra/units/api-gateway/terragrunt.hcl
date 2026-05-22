include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependencies {
  paths = ["../dns-hosted-zone"]
}

terraform {
  source = "${get_repo_root()}//infra/modules/api-gateway"
}

inputs = values
