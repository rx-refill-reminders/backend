# Cognito User Pool - Core identity provider
resource "aws_cognito_user_pool" "pool" {
  name = var.pool_name

  # Allow users to sign themselves up
  auto_verified_attributes = ["email"]

  # Use email as username for simpler UX
  username_attributes = ["email"]

  # MFA configuration (optional for now)
  mfa_configuration = var.mfa_configuration

  # Password policy
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_uppercase                = true
    require_numbers                  = true
    require_symbols                  = true
    temporary_password_validity_days = 7
  }

  # User attributes schema
  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = false

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    name                = "given_name"
    attribute_data_type = "String"
    required            = false
    mutable             = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    name                = "family_name"
    attribute_data_type = "String"
    required            = false
    mutable             = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  # Email verification settings
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Your verification code for ${var.pool_name}"
    email_message        = "Your verification code is {####}"
  }

  # Account recovery settings
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  # User pool add-ons
  user_pool_add_ons {
    advanced_security_mode = "OFF" # Can enable AUDIT or ENFORCED later
  }

  dynamic "lambda_config" {
    for_each = var.lambda_trigger_arns != null ? [1] : []
    content {
      post_confirmation   = try(var.lambda_trigger_arns.post_confirmation, null)
      post_authentication = try(var.lambda_trigger_arns.post_authentication, null)
    }
  }
}

# Resource Server - Defines your API as an OAuth resource
resource "aws_cognito_resource_server" "api" {
  identifier   = var.resource_server_identifier
  name         = var.resource_server_name
  user_pool_id = aws_cognito_user_pool.pool.id

  # Define custom scopes
  dynamic "scope" {
    for_each = var.resource_server_scopes
    content {
      scope_name        = scope.value.name
      scope_description = scope.value.description
    }
  }
}

# iOS App Client - For user authentication
resource "aws_cognito_user_pool_client" "ios_app" {
  name         = "${var.app_client_name}-ios"
  user_pool_id = aws_cognito_user_pool.pool.id

  # OAuth settings
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes = concat(
    ["email", "openid", "profile"],
    [for scope in var.resource_server_scopes : "${var.resource_server_identifier}/${scope.name}"]
  )

  # Callback URLs for iOS app
  callback_urls = var.ios_callback_urls
  logout_urls   = var.ios_logout_urls

  # Supported identity providers
  supported_identity_providers = concat(
    ["COGNITO"],
    var.enable_apple_signin ? ["SignInWithApple"] : [],
    var.enable_google_signin ? ["Google"] : []
  )

  # Token validity periods
  access_token_validity  = 60 # 1 hour
  id_token_validity      = 60 # 1 hour
  refresh_token_validity = 30 # 30 days

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

  # Enable PKCE for security
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  # Prevent client secret (not needed for PKCE flow)
  generate_secret = false

  # Read/write attributes
  read_attributes = [
    "email",
    "email_verified",
    "given_name",
    "family_name"
  ]

  write_attributes = [
    "email",
    "given_name",
    "family_name"
  ]

  depends_on = [aws_cognito_resource_server.api]
}

# Web App Client - For user authentication via web browser
resource "aws_cognito_user_pool_client" "web_app" {
  count = var.enable_web_client ? 1 : 0

  name         = "${var.app_client_name}-web"
  user_pool_id = aws_cognito_user_pool.pool.id

  # OAuth settings
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes = concat(
    ["email", "openid", "profile"],
    [for scope in var.resource_server_scopes : "${var.resource_server_identifier}/${scope.name}"]
  )

  # Callback URLs for web app
  callback_urls = var.web_callback_urls
  logout_urls   = var.web_logout_urls

  # Supported identity providers
  supported_identity_providers = concat(
    ["COGNITO"],
    var.enable_apple_signin ? ["SignInWithApple"] : [],
    var.enable_google_signin ? ["Google"] : []
  )

  # Token validity periods
  access_token_validity  = 60 # 1 hour
  id_token_validity      = 60 # 1 hour
  refresh_token_validity = 30 # 30 days

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

  # Web apps can use PKCE or client secret - we'll use PKCE for security
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  # No client secret for public web apps (using PKCE)
  generate_secret = false

  # Read/write attributes
  read_attributes = [
    "email",
    "email_verified",
    "given_name",
    "family_name"
  ]

  write_attributes = [
    "email",
    "given_name",
    "family_name"
  ]

  depends_on = [aws_cognito_resource_server.api]
}

# Service Client - For machine-to-machine authentication
resource "aws_cognito_user_pool_client" "service" {
  count = var.enable_service_client ? 1 : 0

  name         = "${var.app_client_name}-service"
  user_pool_id = aws_cognito_user_pool.pool.id

  # OAuth settings for client credentials flow
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_scopes = [
    for scope in var.resource_server_scopes : "${var.resource_server_identifier}/${scope.name}"
  ]

  # Token validity
  access_token_validity = 60 # 1 hour

  token_validity_units {
    access_token = "minutes"
  }

  # Service clients need a secret
  generate_secret = true

  depends_on = [aws_cognito_resource_server.api]
}

# Store service client secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "service_client_secret" {
  count = var.enable_service_client ? 1 : 0

  name        = "${var.pool_name}-service-client-secret"
  description = "Service client secret for ${var.pool_name}"

  tags = module.tags
}

resource "aws_secretsmanager_secret_version" "service_client_secret" {
  count = var.enable_service_client ? 1 : 0

  secret_id = aws_secretsmanager_secret.service_client_secret[0].id
  secret_string = jsonencode({
    client_id      = aws_cognito_user_pool_client.service[0].id
    client_secret  = aws_cognito_user_pool_client.service[0].client_secret
    user_pool_id   = aws_cognito_user_pool.pool.id
    cognito_domain = aws_cognito_user_pool_domain.domain.domain
    token_endpoint = "${local.cognito_url}/oauth2/token"
  })
}

# Apple Identity Provider (optional)
resource "aws_cognito_identity_provider" "apple" {
  count = var.enable_apple_signin && var.apple_signin_config != null ? 1 : 0

  user_pool_id  = aws_cognito_user_pool.pool.id
  provider_name = "SignInWithApple"
  provider_type = "SignInWithApple"

  provider_details = {
    client_id                 = var.apple_signin_config.client_id
    team_id                   = var.apple_signin_config.team_id
    key_id                    = var.apple_signin_config.key_id
    private_key               = var.apple_signin_config.private_key
    authorize_scopes          = "email name"
    attributes_request_method = "GET"
  }

  attribute_mapping = {
    email       = "email"
    username    = "sub"
    given_name  = "firstName"
    family_name = "lastName"
  }
}

# Google Identity Provider (optional)
resource "aws_cognito_identity_provider" "google" {
  count = var.enable_google_signin && var.google_signin_config != null ? 1 : 0

  user_pool_id  = aws_cognito_user_pool.pool.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    client_id        = var.google_signin_config.client_id
    client_secret    = var.google_signin_config.client_secret
    authorize_scopes = "email openid profile"
  }

  attribute_mapping = {
    email       = "email"
    username    = "sub"
    given_name  = "given_name"
    family_name = "family_name"
  }
}
