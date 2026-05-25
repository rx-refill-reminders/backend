include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "dns" {
  config_path = "../dns-hosted-zone"

  mock_outputs = {
    zone_id = "Z000000000000000000000"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependencies {
  paths = ["../dns-hosted-zone"]
}

terraform {
  source = "git::github.com/rx-refill-reminders/terraform-modules//modules/cognito-user-pool?ref=cognito-user-pool%2Fv0&depth=0"
}

inputs = merge(
  values,
  {
    domain = try(values.domain, null) == null ? null : {
      zone_id  = dependency.dns.outputs.zone_id
      hostname = values.domain.hostname
    }
  },
)
