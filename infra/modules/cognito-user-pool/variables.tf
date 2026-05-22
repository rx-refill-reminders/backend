variable "env" {
  description = "Environment: dev, prod, or common"
  type        = string

  validation {
    condition     = contains(["dev", "prod", "common"], var.env)
    error_message = "The value of \"env\" must be either \"dev\", \"prod\", or \"common\""
  }
}

variable "pool_name" {
  description = "Base name for the Cognito User Pool"
  type        = string
  default     = "wanderertrip"
}

variable "domain_prefix" {
  description = "Domain prefix for Cognito Hosted UI (will be suffixed with -env)"
  type        = string
  default     = "wanderertrip"
}

# Custom Domain Configuration
variable "domain_alias" {
  description = "Custom domain configuration for Cognito Hosted UI. If provided, uses custom domain instead of default Cognito domain."
  type = object({
    domain_name     = string # e.g., "auth.wanderertrip.com"
    certificate_arn = string # ACM certificate ARN (must be in us-east-1)
    zone_id         = string # Route53 hosted zone ID for creating alias record
  })
  default = null
}

variable "app_client_name" {
  description = "Base name for app clients"
  type        = string
  default     = "wanderertrip"
}

variable "resource_server_identifier" {
  description = "Identifier for the API resource server (typically your API URL)"
  type        = string
  default     = "https://api.wanderertrip.com"
}

variable "resource_server_name" {
  description = "Name for the resource server"
  type        = string
  default     = "WandererTrip API"
}

variable "resource_server_scopes" {
  description = "List of OAuth scopes for the API"
  type = list(object({
    name        = string
    description = string
  }))
  default = [
    {
      name        = "access"
      description = "Access to WandererTrip API"
    }
  ]
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
