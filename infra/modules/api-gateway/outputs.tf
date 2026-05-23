output "gateway_id" {
  value = aws_apigatewayv2_api.api.id
}

output "gateway_arn" {
  value = aws_apigatewayv2_api.api.arn
}

output "gateway_execution_arn" {
  value = aws_apigatewayv2_api.api.execution_arn
}

output "stage_arn" {
  value = aws_apigatewayv2_stage.stage.arn
}

output "stage_url" {
  value = aws_apigatewayv2_stage.stage.invoke_url
}

output "api_url" {
  description = "Public HTTPS URL for the API custom domain (null when domain is not configured)"
  value       = var.domain != null ? "https://${var.domain.hostname}" : null
}

output "api_hostname" {
  description = "Custom API hostname (null when domain is not configured)"
  value       = var.domain != null ? var.domain.hostname : null
}

output "custom_domain_name" {
  description = "API Gateway custom domain name resource ID (null when domain is not configured)"
  value       = var.domain != null ? aws_apigatewayv2_domain_name.domain[0].id : null
}
