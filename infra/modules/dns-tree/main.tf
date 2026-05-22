locals {
  api_subdomain  = "api.${var.domain}"
  auth_subdomain = "auth.${var.domain}"
}

import {
  for_each = var.import_hosted_zone_id == null ? tomap({}) : tomap({ root : var.import_hosted_zone_id })
  to       = aws_route53_zone.zone[each.key]
  id       = each.value
}

moved {
  from = aws_route53_zone.zone
  to   = aws_route53_zone.zone["root"]
}

resource "aws_route53_zone" "zone" {
  for_each = tomap({ root : "" })
  name     = var.domain
}

module "root_cert" {
  source = "../acm-dns-certificate"

  domain_name = var.domain
  zone_id     = aws_route53_zone.zone["root"].zone_id
  validate    = var.validate
}

module "api_cert" {
  source = "../acm-dns-certificate"

  domain_name = local.api_subdomain
  zone_id     = aws_route53_zone.zone["root"].zone_id
  validate    = var.validate
}

module "auth_cert" {
  source = "../acm-dns-certificate"

  domain_name = local.auth_subdomain
  zone_id     = aws_route53_zone.zone["root"].zone_id
  validate    = var.validate
}

resource "aws_route53_record" "delegated" {
  count = var.delegate_subdomain == null ? 0 : 1

  zone_id = aws_route53_zone.zone["root"].zone_id
  name    = try(var.delegate_subdomain.domain, "")
  type    = "NS"
  ttl     = 300
  records = try(var.delegate_subdomain.nameservers, [])
}
