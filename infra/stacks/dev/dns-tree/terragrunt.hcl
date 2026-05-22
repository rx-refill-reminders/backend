include "stack" {
  path   = find_in_parent_folders("terragrunt.hcl")
  expose = true
}

terraform {
  source = "${get_repo_root()}//infra/modules/dns-tree"
}

inputs = {
  domain   = include.stack.locals.domain
  validate = false
}
