output "user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.pool.id
}

output "user_pool_arn" {
  description = "The ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.pool.arn
}

output "user_pool_endpoint" {
  description = "The endpoint of the Cognito User Pool"
  value       = aws_cognito_user_pool.pool.endpoint
}

output "hosted_ui_url" {
  description = "The base URL for Cognito Hosted UI"
  value       = local.cognito_url
}

output "ios_client_id" {
  description = "The client ID for the iOS app"
  value       = aws_cognito_user_pool_client.ios_app.id
}

output "web_client_id" {
  description = "The client ID for the web app"
  value       = var.enable_web_client ? aws_cognito_user_pool_client.web_app[0].id : null
}

output "service_client_id" {
  description = "The client ID for the service client"
  value       = var.enable_service_client ? aws_cognito_user_pool_client.service[0].id : null
}

output "service_client_secret_arn" {
  description = "The ARN of the Secrets Manager secret containing service client credentials"
  value       = var.enable_service_client ? aws_secretsmanager_secret.service_client_secret[0].arn : null
}

output "service_client_secret_name" {
  description = "The name of the Secrets Manager secret containing service client credentials"
  value       = var.enable_service_client ? aws_secretsmanager_secret.service_client_secret[0].name : null
}

output "resource_server_identifier" {
  description = "The identifier of the resource server"
  value       = aws_cognito_resource_server.api.identifier
}

output "resource_server_scopes" {
  description = "List of full scope identifiers (resource_server_id/scope_name)"
  value = [
    for scope in var.resource_server_scopes : "${var.resource_server_identifier}/${scope.name}"
  ]
}
