module "tags" {
  source = "../../lib/default-tags"
  env    = var.env
}

locals {
  api_subdomain  = "api.${var.domain}"
  auth_subdomain = "auth.${var.domain}"
}

resource "aws_route53_zone" "zone" {
  name = var.domain

  tags = module.tags
}

module "web_cert" {
  source = "../../lib/acm-dns-certificate"

  env         = var.env
  domain_name = local.domain_name
  zone_id     = aws_route53_zone.zone.zone_id
  validate    = var.validate
}

module "api_cert" {
  source = "../../lib/acm-dns-certificate"

  env         = var.env
  domain_name = local.api_subdomain
  zone_id     = aws_route53_zone.zone.zone_id
  validate    = var.validate
}

module "auth_cert" {
  source = "../../lib/acm-dns-certificate"

  env         = var.env
  domain_name = local.auth_subdomain
  zone_id     = aws_route53_zone.zone.zone_id
  validate    = var.validate
}

resource "aws_route53_record" "delegated" {
  count = var.delegate_subdomain == null ? 0 : 1

  zone_id = aws_route53_zone.zone.zone_id
  name    = try(var.delegate_subdomain.domain, "")
  type    = "NS"
  ttl     = 300
  records = try(var.delegate_subdomain.nameservers, [])
}
