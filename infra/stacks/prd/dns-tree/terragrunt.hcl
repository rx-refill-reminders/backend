include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}/infra/modules/dns-tree"
}

inputs = {
  domain   = include.env.locals.domain
  validate = false
}
