variable "use_existing_zone" {
  type        = bool
  default     = false
  description = "If true, searches for an existing hosted zone rather than creating a new one"
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
