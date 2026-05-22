locals {
  domain = "rx-refill-reminders.com"
}

unit "dns_tree" {
  source = "${get_repo_root()}/infra/units/dns-tree"
  path   = "dns-tree"

  values = {
    domain   = local.domain
    validate = false
  }
}
