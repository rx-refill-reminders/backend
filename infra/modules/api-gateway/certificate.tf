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
