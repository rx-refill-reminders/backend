locals {
  domain = "rx-refill-reminders.com"
}

unit "dns_tree" {
  source = "${get_repo_root()}/infra/units/dns-tree"
  path   = "dns-tree"

  values = {
    import_hosted_zone_id = "Z07465232HRS85ZSQYRZY"
    domain                = local.domain
    validate              = true

    // delegate_subdomain = {
    //   domain = "dev.rx-refill-reminders.com"
    //   nameservers = [
    //     "ns-1089.awsdns-08.org",
    //     "ns-1968.awsdns-54.co.uk",
    //     "ns-236.awsdns-29.com",
    //     "ns-688.awsdns-22.net",
    //   ]
    // }
  }
}
