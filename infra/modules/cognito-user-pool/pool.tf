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
