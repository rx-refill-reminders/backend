output "zone_id" {
  description = "The hosted zone ID"
  value       = local.root_zone_id
}

output "zone_name" {
  description = "The hosted zone name"
  value       = local.root_zone_name
}

output "name_servers" {
  description = "Route53 name servers for the hosted zone"
  value       = local.root_zone_nameservers
}

output "certificate_arn" {
  description = "ACM certificate ARN for the root domain"
  value       = module.acm_cert.certificate_arn
}
