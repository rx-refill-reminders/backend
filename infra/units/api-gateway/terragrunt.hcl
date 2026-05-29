include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::github.com/rx-refill-reminders/terraform-modules//modules/api-gateway?ref=api-gateway%2Fv0&depth=0"
}

inputs = values
