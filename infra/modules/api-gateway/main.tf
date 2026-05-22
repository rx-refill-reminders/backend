resource "aws_apigatewayv2_api" "api" {
  name          = var.name
  protocol_type = "HTTP"

  cors_configuration {
    allow_headers = ["*"]
    allow_origins = ["*"]
    allow_methods = ["*"]
    max_age       = 360
  }
}

resource "aws_cloudwatch_log_group" "gateway_logs" {
  name              = "/aws/api_gw/${var.name}"
  retention_in_days = 30
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "${var.name}-stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.gateway_logs.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}
