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

output "root_certificate_arn" {
  description = "ACM certificate ARN for the root domain"
  value       = module.root_cert.certificate_arn
}

output "root_domain" {
  description = "Web domain name (root or dev subdomain)"
  value       = var.domain
}

output "api_certificate_arn" {
  description = "ACM certificate ARN for the API subdomain"
  value       = module.api_cert.certificate_arn
}

output "api_domain" {
  description = "API subdomain name"
  value       = local.api_subdomain
}

output "auth_certificate_arn" {
  description = "ACM certificate ARN for the auth subdomain"
  value       = module.auth_cert.certificate_arn
}

output "auth_domain" {
  description = "Auth subdomain name"
  value       = local.auth_subdomain
}
