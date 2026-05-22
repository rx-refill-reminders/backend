include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Apply after dns-hosted-zone (ordering only; domain_alias not wired yet).
dependencies {
  paths = ["../dns-hosted-zone"]
}

terraform {
  source = "${get_repo_root()}//infra/modules/cognito-user-pool"
}

inputs = values
