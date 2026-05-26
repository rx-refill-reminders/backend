locals {
  domain = "rx-refill-reminders.com"

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
    use_existing_zone = true
    domain            = local.domain
    validate          = true

    delegate_subdomain = {
      domain = "dev.rx-refill-reminders.com"
      nameservers = [
        "ns-1089.awsdns-08.org",
        "ns-1968.awsdns-54.co.uk",
        "ns-236.awsdns-29.com",
        "ns-688.awsdns-22.net",
      ]
    }
  }
}

unit "cognito_user_pool" {
  source = "${get_repo_root()}/infra/units/cognito-user-pool"
  path   = "cognito-user-pool"

  values = {
    pool_name                  = "rx-refill-reminders"
    app_client_name            = "rx-refill-reminders"
    domain_prefix              = "rx-refill-reminders-prd"
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
        method                = "ANY"
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
