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
