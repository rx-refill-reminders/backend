locals {
  domain = "dev.rx-refill-reminders.com"
}

unit "dns_tree" {
  source = "${get_repo_root()}/infra/units/dns-tree"
  path   = "dns-tree"

  values = {
    import_hosted_zone_id = "Z08427401W2SCGIP77L8A"
    domain                = local.domain
    validate              = false
  }
}
