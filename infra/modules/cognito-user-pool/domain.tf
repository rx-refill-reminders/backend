data "aws_region" "current" {}

locals {
  default_domain_prefix    = var.domain_prefix
  default_cognito_hostname = "${local.default_domain_prefix}.auth.${data.aws_region.current.region}.amazoncognito.com"

  cognito_hostname = var.domain != null ? var.domain.hostname : local.default_cognito_hostname
  cognito_url      = "https://${local.cognito_hostname}"
}

resource "aws_cognito_user_pool_domain" "default_domain" {
  domain       = local.default_domain_prefix
  user_pool_id = aws_cognito_user_pool.pool.id
}

module "custom_domain_cert" {
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

resource "aws_route53_record" "custom_domain_alias" {
  count = var.domain != null ? 1 : 0

  name    = var.domain.hostname
  zone_id = var.domain.zone_id
  type    = "A"

  alias {
    name                   = aws_cognito_user_pool_domain.default_domain.cloudfront_distribution
    zone_id                = aws_cognito_user_pool_domain.default_domain.cloudfront_distribution_zone_id
    evaluate_target_health = false
  }
}
