variable "name" {
  description = "API Gateway name (also used for the stage and CloudWatch log group path)"
  type        = string
}

variable "domain" {
  description = "Custom domain for the API (ACM cert, API Gateway domain, Route53 alias). Omit for execute-api URL only."
  type = object({
    zone_id  = string
    hostname = string
  })
  default = null
}
