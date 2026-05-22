include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//infra/modules/dns-tree"
}

inputs = {
  domain   = values.domain
  validate = values.validate
}
