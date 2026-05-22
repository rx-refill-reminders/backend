output "zone_id" {
  description = "The hosted zone ID"
  value       = aws_route53_zone.zone.zone_id
}

output "zone_name" {
  description = "The hosted zone name"
  value       = aws_route53_zone.zone.name
}

output "name_servers" {
  description = "Route53 name servers for the hosted zone"
  value       = aws_route53_zone.zone.name_servers
}

output "web_certificate_arn" {
  description = "ACM certificate ARN for the web domain"
  value       = module.web_cert.certificate_arn
}

output "web_domain" {
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
