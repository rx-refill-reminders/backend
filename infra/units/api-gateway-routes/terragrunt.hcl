include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "api_gateway" {
  config_path = "../api-gateway"

  mock_outputs = {
    gateway_id            = "abc123"
    gateway_execution_arn = "arn:aws:execute-api:us-east-1:123456789012:abc123"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependencies {
  paths = ["../api-gateway"]
}

terraform {
  source = "git::github.com/rx-refill-reminders/terraform-modules//modules/api-gateway-routes?ref=api-gateway-routes%2Fv0&depth=0"
}

inputs = merge(
  values,
  {
    api_id                = dependency.api_gateway.outputs.gateway_id
    gateway_execution_arn = dependency.api_gateway.outputs.gateway_execution_arn
  },
)
