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
