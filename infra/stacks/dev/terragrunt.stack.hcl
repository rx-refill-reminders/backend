locals {
  domain = "dev.rx-refill-reminders.com"
}

unit "dns_hosted_zone" {
  source = "${get_repo_root()}/infra/units/dns-hosted-zone"
  path   = "dns-hosted-zone"

  values = {
    domain   = local.domain
    validate = false
  }
}
