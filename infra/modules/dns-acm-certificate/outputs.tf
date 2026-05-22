output "certificate_arn" {
  # Return validated certificate ARN if validation is enabled, otherwise the certificate ARN
  value = var.validate && length(aws_acm_certificate_validation.validation) > 0 ? aws_acm_certificate_validation.validation[0].certificate_arn : aws_acm_certificate.certificate.arn
}
