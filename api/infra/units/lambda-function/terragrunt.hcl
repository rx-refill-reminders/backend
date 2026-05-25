include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::github.com/rx-refill-reminders/terraform-modules//modules/lambda-function?ref=lambda-function%2Fv0&depth=0"
}

inputs = values
