data "aws_region" "current" {}

locals {
  default_domain_prefix    = var.domain_prefix
  default_cognito_hostname = "${local.default_domain_prefix}.auth.${data.aws_region.current.region}.amazoncognito.com"

  cognito_hostname = var.domain_alias == null ? local.default_cognito_hostname : var.domain_alias.domain_name
  cognito_url      = "https://${local.cognito_hostname}"
}

# Cognito User Pool Domain for Hosted UI
# Uses custom domain if provided, otherwise uses default Cognito domain
resource "aws_cognito_user_pool_domain" "domain" {
  domain       = var.domain_alias != null ? var.domain_alias.domain_name : local.default_domain_prefix
  user_pool_id = aws_cognito_user_pool.pool.id

  # If custom domain is provided, use ACM certificate
  # Certificate MUST be in us-east-1 (CloudFront requirement)
  certificate_arn = var.domain_alias != null ? var.domain_alias.certificate_arn : null
}

# Route53 ALIAS record pointing to Cognito CloudFront distribution
# Only created when custom domain is configured
resource "aws_route53_record" "cognito_alias" {
  count = var.domain_alias != null ? 1 : 0

  name    = aws_cognito_user_pool_domain.domain.domain
  zone_id = var.domain_alias.zone_id
  type    = "A"

  alias {
    name                   = aws_cognito_user_pool_domain.domain.cloudfront_distribution
    zone_id                = aws_cognito_user_pool_domain.domain.cloudfront_distribution_zone_id
    evaluate_target_health = false
  }
}
