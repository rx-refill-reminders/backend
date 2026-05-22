include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  domain = "dev.rx-refill-reminders.com"
}
