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

  name        = "cognito/${var.pool_name}/client-secret/service"
  description = "Service client secret for ${var.pool_name}"
}

resource "aws_secretsmanager_secret_version" "service_client_secret" {
  count = var.enable_service_client ? 1 : 0

  secret_id = aws_secretsmanager_secret.service_client_secret[0].id
  secret_string = jsonencode({
    client_id      = aws_cognito_user_pool_client.service[0].id
    client_secret  = aws_cognito_user_pool_client.service[0].client_secret
    user_pool_id   = aws_cognito_user_pool.pool.id
    cognito_domain = aws_cognito_user_pool_domain.default_domain.domain
    token_endpoint = "${local.cognito_url}/oauth2/token"
  })
}
