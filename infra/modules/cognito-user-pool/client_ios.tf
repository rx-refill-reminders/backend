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
