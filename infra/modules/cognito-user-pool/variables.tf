variable "pool_name" {
  description = "Base name for the Cognito User Pool"
  type        = string
}

variable "domain_prefix" {
  description = "Domain prefix for Cognito Hosted UI (will be suffixed with -env)"
  type        = string
}

# Custom domain for Cognito Hosted UI (auth.<root-domain>). Omit for default Cognito domain prefix.
variable "domain" {
  type = object({
    zone_id  = string
    hostname = string
  })
  default = null
}

variable "app_client_name" {
  description = "Base name for app clients"
  type        = string
}

variable "resource_server_identifier" {
  description = "Identifier for the API resource server (typically your API URL)"
  type        = string
}

variable "resource_server_name" {
  description = "Name for the resource server"
  type        = string
}

variable "resource_server_scopes" {
  description = "List of OAuth scopes for the API"
  type = list(object({
    name        = string
    description = string
  }))
}

variable "ios_callback_urls" {
  description = "Callback URLs for iOS app after authentication"
  type        = list(string)
}

variable "ios_logout_urls" {
  description = "Logout URLs for iOS app"
  type        = list(string)
}

variable "enable_web_client" {
  description = "Whether to create a web app client for user authentication"
  type        = bool
  default     = false
}

variable "web_callback_urls" {
  description = "Callback URLs for web app after authentication"
  type        = list(string)
  default     = []
}

variable "web_logout_urls" {
  description = "Logout URLs for web app"
  type        = list(string)
  default     = []
}

variable "enable_service_client" {
  description = "Whether to create a service client for machine-to-machine auth"
  type        = bool
  default     = true
}

variable "mfa_configuration" {
  description = "MFA configuration: OFF, ON, or OPTIONAL"
  type        = string
  default     = "OFF"

  validation {
    condition     = contains(["OFF", "ON", "OPTIONAL"], var.mfa_configuration)
    error_message = "MFA configuration must be OFF, ON, or OPTIONAL"
  }
}

# Social Sign-In Configuration

variable "enable_apple_signin" {
  description = "Enable Sign in with Apple"
  type        = bool
  default     = false
}

variable "apple_signin_config" {
  description = "Configuration for Apple Sign In"
  type = object({
    client_id   = string
    team_id     = string
    key_id      = string
    private_key = string
  })
  default   = null
  sensitive = true
}

variable "enable_google_signin" {
  description = "Enable Sign in with Google"
  type        = bool
  default     = false
}

variable "google_signin_config" {
  description = "Configuration for Google Sign In"
  type = object({
    client_id     = string
    client_secret = string
  })
  default   = null
  sensitive = true
}

variable "lambda_trigger_arns" {
  description = "ARNs of Lambdas to invoke for Cognito triggers. When set, a lambda_config block is created from it."
  type = object({
    post_confirmation   = optional(string)
    post_authentication = optional(string)
  })
  default = null
}
