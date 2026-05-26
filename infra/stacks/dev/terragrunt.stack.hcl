locals {
  domain = "dev.rx-refill-reminders.com"

  cognito_resource_server_scopes = [
    {
      name        = "access"
      description = "Full API access"
    },
  ]
}

unit "dns_hosted_zone" {
  source = "${get_repo_root()}/infra/units/dns-hosted-zone"
  path   = "dns-hosted-zone"

  values = {
    domain   = local.domain
    validate = true
  }
}

unit "cognito_user_pool" {
  source = "${get_repo_root()}/infra/units/cognito-user-pool"
  path   = "cognito-user-pool"

  values = {
    pool_name                  = "rx-refill-reminders"
    app_client_name            = "rx-refill-reminders"
    domain_prefix              = "rx-refill-reminders-dev"
    resource_server_identifier = "https://api.${local.domain}"
    resource_server_name       = "Rx Refill Reminders API"
    resource_server_scopes     = local.cognito_resource_server_scopes

    ios_callback_urls = [
      "rxrefillreminders://callback",
    ]
    ios_logout_urls = [
      "rxrefillreminders://logout",
    ]

    enable_web_client     = false
    enable_service_client = true
    enable_apple_signin   = false
    enable_google_signin  = false

    domain = {
      hostname = "auth.${local.domain}"
    }
  }
}

unit "api_gateway" {
  source = "${get_repo_root()}/infra/units/api-gateway"
  path   = "api-gateway"

  values = {
    name = "api"

    domain = {
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

unit "dynamodb_users" {
  source = "${get_repo_root()}/infra/units/dynamodb-table"
  path   = "dynamodb-users"

  values = {
    table_name = "users"
    hash_key   = "userId"
    attributes = [
      { name = "userId", type = "S" },
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
