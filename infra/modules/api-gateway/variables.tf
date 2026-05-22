variable "name" {
  description = "Gateway name prefix (suffixed with env)"
  type        = string
}

variable "env" {
  description = "Environment suffix (dev or prd)"
  type        = string
}
