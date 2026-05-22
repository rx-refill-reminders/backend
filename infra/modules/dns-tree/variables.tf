variable "import_hosted_zone_id" {
  type        = string
  default     = null
  description = "Hosted zone ID to import as the root zone, if needed"
}

variable "validate" {
  type    = bool
  default = false
}

variable "domain" {
  description = "Domain name for the hosted zone"
}

variable "delegate_subdomain" {
  description = "Delegate a subdomain to another hosted zone, if need be"
  type = object({
    domain      = string
    nameservers = list(string)
  })
  default = null
}
