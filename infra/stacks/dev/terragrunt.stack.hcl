locals {
  hosted_zone_id = "Z08427401W2SCGIP77L8A"
  domain         = "dev.rx-refill-reminders.com"
}

unit "api_gateway" {
  source = "${get_repo_root()}/infra/units/api-gateway"
  path   = "api-gateway"

  values = {
    name = "api"

    domain = {
      zone_id  = local.hosted_zone_id
      hostname = "api.${local.domain}"
    }
  }
}

unit "lambda_role" {
  source = "${get_repo_root()}/infra/units/lambda-role"
  path   = "lambda-role"

  values = {
    role_name = "backend-api-lambda"
  }
}

unit "api_gateway_routes" {
  source = "${get_repo_root()}/infra/units/api-gateway-routes"
  path   = "api-gateway-routes"

  values = {
    endpoints = [
      {
        route                 = "/openapi.yaml"
        method                = "GET"
        handler_function_name = "backend-api-handler"
      },
      {
        route                 = "/openapi.json"
        method                = "GET"
        handler_function_name = "backend-api-handler"
      },
      {
        route                 = "/docs"
        method                = "GET"
        handler_function_name = "backend-api-handler"
      },
      {
        route                 = "/{proxy+}"
        method                = "ANY"
        handler_function_name = "backend-api-handler"
      },
    ]
  }
}

unit "dynamodb_rx_cycles" {
  source = "${get_repo_root()}/infra/units/dynamodb-table"
  path   = "dynamodb-rx-cycles"

  values = {
    table_name = "rx-cycles"
    hash_key   = "userId"
    range_key  = "cycleId"
    attributes = [
      { name = "userId", type = "S" },
      { name = "cycleId", type = "S" },
    ]
  }
}

unit "dynamodb_rx_cycle_instances" {
  source = "${get_repo_root()}/infra/units/dynamodb-table"
  path   = "dynamodb-rx-cycle-instances"

  values = {
    table_name = "rx-cycle-instances"
    hash_key   = "cycleId"
    range_key  = "instanceId"
    attributes = [
      { name = "cycleId", type = "S" },
      { name = "instanceId", type = "S" },
    ]
  }
}

unit "dynamodb_reminders" {
  source = "${get_repo_root()}/infra/units/dynamodb-table"
  path   = "dynamodb-reminders"

  values = {
    table_name = "reminders"
    hash_key   = "reminderId"
    attributes = [
      { name = "reminderId", type = "S" },
      { name = "status", type = "S" },
      { name = "scheduledAt", type = "N" },
    ]
    global_secondary_index_map = [
      {
        name            = "by-schedule"
        hash_key        = "status"
        range_key       = "scheduledAt"
        projection_type = "ALL"
      },
    ]
  }
}
