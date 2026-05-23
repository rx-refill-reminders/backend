module "api_cert" {
  count = var.domain != null ? 1 : 0

  source = "../dns-acm-certificate"

  domain_name = var.domain.hostname
  zone_id     = var.domain.zone_id
  validate    = true

  providers = {
    aws.default   = aws
    aws.us_east_1 = aws.us_east_1
  }
}

resource "aws_apigatewayv2_domain_name" "domain" {
  count = var.domain != null ? 1 : 0

  domain_name = var.domain.hostname

  domain_name_configuration {
    certificate_arn = module.api_cert[0].certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "mapping" {
  count = var.domain != null ? 1 : 0

  api_id      = aws_apigatewayv2_api.api.id
  domain_name = aws_apigatewayv2_domain_name.domain[0].id
  stage       = aws_apigatewayv2_stage.stage.name
}

resource "aws_route53_record" "alias" {
  count = var.domain != null ? 1 : 0

  zone_id = var.domain.zone_id
  name    = var.domain.hostname
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.domain[0].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.domain[0].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
