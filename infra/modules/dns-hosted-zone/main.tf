moved {
  from = aws_route53_zone.zone
  to   = aws_route53_zone.zone[0]
}

resource "aws_route53_zone" "zone" {
  count = var.use_existing_zone ? 0 : 1
  name  = var.domain
}

data "aws_route53_zone" "existing_zone" {
  count = var.use_existing_zone ? 1 : 0
  name  = var.domain
}

locals {
  root_zone_id          = var.use_existing_zone ? data.aws_route53_zone.existing_zone[0].zone_id : aws_route53_zone.zone[0].zone_id
  root_zone_name        = var.use_existing_zone ? data.aws_route53_zone.existing_zone[0].name : aws_route53_zone.zone[0].name
  root_zone_nameservers = var.use_existing_zone ? data.aws_route53_zone.existing_zone[0].name_servers : aws_route53_zone.zone[0].name_servers
}

moved {
  from = module.root_cert
  to   = module.acm_cert
}

module "acm_cert" {
  source = "../dns-acm-certificate"

  domain_name = var.domain
  zone_id     = local.root_zone_id
  validate    = var.validate

  providers = {
    aws.default   = aws
    aws.us_east_1 = aws.us_east_1
  }
}

resource "aws_route53_record" "delegated" {
  count = var.delegate_subdomain == null ? 0 : 1

  zone_id = local.root_zone_id
  name    = try(var.delegate_subdomain.domain, "")
  type    = "NS"
  ttl     = 300
  records = try(var.delegate_subdomain.nameservers, [])
}
