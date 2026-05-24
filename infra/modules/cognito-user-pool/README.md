# cognito-user-pool

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_custom_domain_cert"></a> [custom\_domain\_cert](#module\_custom\_domain\_cert) | ../dns-acm-certificate | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cognito_identity_provider.apple](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_provider) | resource |
| [aws_cognito_identity_provider.google](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_provider) | resource |
| [aws_cognito_resource_server.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_resource_server) | resource |
| [aws_cognito_user_pool.pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.ios_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_client.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_client.web_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_domain.default_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain) | resource |
| [aws_route53_record.custom_domain_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_secretsmanager_secret.service_client_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.service_client_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_client_name"></a> [app\_client\_name](#input\_app\_client\_name) | Base name for app clients | `string` | n/a | yes |
| <a name="input_apple_signin_config"></a> [apple\_signin\_config](#input\_apple\_signin\_config) | Configuration for Apple Sign In | <pre>object({<br/>    client_id   = string<br/>    team_id     = string<br/>    key_id      = string<br/>    private_key = string<br/>  })</pre> | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Custom domain for Cognito Hosted UI (auth.<root-domain>). Omit for default Cognito domain prefix. | <pre>object({<br/>    zone_id  = string<br/>    hostname = string<br/>  })</pre> | `null` | no |
| <a name="input_domain_prefix"></a> [domain\_prefix](#input\_domain\_prefix) | Domain prefix for Cognito Hosted UI (will be suffixed with -env) | `string` | n/a | yes |
| <a name="input_enable_apple_signin"></a> [enable\_apple\_signin](#input\_enable\_apple\_signin) | Enable Sign in with Apple | `bool` | `false` | no |
| <a name="input_enable_google_signin"></a> [enable\_google\_signin](#input\_enable\_google\_signin) | Enable Sign in with Google | `bool` | `false` | no |
| <a name="input_enable_service_client"></a> [enable\_service\_client](#input\_enable\_service\_client) | Whether to create a service client for machine-to-machine auth | `bool` | `true` | no |
| <a name="input_enable_web_client"></a> [enable\_web\_client](#input\_enable\_web\_client) | Whether to create a web app client for user authentication | `bool` | `false` | no |
| <a name="input_google_signin_config"></a> [google\_signin\_config](#input\_google\_signin\_config) | Configuration for Google Sign In | <pre>object({<br/>    client_id     = string<br/>    client_secret = string<br/>  })</pre> | `null` | no |
| <a name="input_ios_callback_urls"></a> [ios\_callback\_urls](#input\_ios\_callback\_urls) | Callback URLs for iOS app after authentication | `list(string)` | n/a | yes |
| <a name="input_ios_logout_urls"></a> [ios\_logout\_urls](#input\_ios\_logout\_urls) | Logout URLs for iOS app | `list(string)` | n/a | yes |
| <a name="input_lambda_trigger_arns"></a> [lambda\_trigger\_arns](#input\_lambda\_trigger\_arns) | ARNs of Lambdas to invoke for Cognito triggers. When set, a lambda\_config block is created from it. | <pre>object({<br/>    post_confirmation   = optional(string)<br/>    post_authentication = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_mfa_configuration"></a> [mfa\_configuration](#input\_mfa\_configuration) | MFA configuration: OFF, ON, or OPTIONAL | `string` | `"OFF"` | no |
| <a name="input_pool_name"></a> [pool\_name](#input\_pool\_name) | Base name for the Cognito User Pool | `string` | n/a | yes |
| <a name="input_resource_server_identifier"></a> [resource\_server\_identifier](#input\_resource\_server\_identifier) | Identifier for the API resource server (typically your API URL) | `string` | n/a | yes |
| <a name="input_resource_server_name"></a> [resource\_server\_name](#input\_resource\_server\_name) | Name for the resource server | `string` | n/a | yes |
| <a name="input_resource_server_scopes"></a> [resource\_server\_scopes](#input\_resource\_server\_scopes) | List of OAuth scopes for the API | <pre>list(object({<br/>    name        = string<br/>    description = string<br/>  }))</pre> | n/a | yes |
| <a name="input_web_callback_urls"></a> [web\_callback\_urls](#input\_web\_callback\_urls) | Callback URLs for web app after authentication | `list(string)` | `[]` | no |
| <a name="input_web_logout_urls"></a> [web\_logout\_urls](#input\_web\_logout\_urls) | Logout URLs for web app | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hosted_ui_url"></a> [hosted\_ui\_url](#output\_hosted\_ui\_url) | The base URL for Cognito Hosted UI |
| <a name="output_ios_client_id"></a> [ios\_client\_id](#output\_ios\_client\_id) | The client ID for the iOS app |
| <a name="output_resource_server_identifier"></a> [resource\_server\_identifier](#output\_resource\_server\_identifier) | The identifier of the resource server |
| <a name="output_resource_server_scopes"></a> [resource\_server\_scopes](#output\_resource\_server\_scopes) | List of full scope identifiers (resource\_server\_id/scope\_name) |
| <a name="output_service_client_id"></a> [service\_client\_id](#output\_service\_client\_id) | The client ID for the service client |
| <a name="output_service_client_secret_arn"></a> [service\_client\_secret\_arn](#output\_service\_client\_secret\_arn) | The ARN of the Secrets Manager secret containing service client credentials |
| <a name="output_service_client_secret_name"></a> [service\_client\_secret\_name](#output\_service\_client\_secret\_name) | The name of the Secrets Manager secret containing service client credentials |
| <a name="output_user_pool_arn"></a> [user\_pool\_arn](#output\_user\_pool\_arn) | The ARN of the Cognito User Pool |
| <a name="output_user_pool_endpoint"></a> [user\_pool\_endpoint](#output\_user\_pool\_endpoint) | The endpoint of the Cognito User Pool |
| <a name="output_user_pool_id"></a> [user\_pool\_id](#output\_user\_pool\_id) | The ID of the Cognito User Pool |
| <a name="output_web_client_id"></a> [web\_client\_id](#output\_web\_client\_id) | The client ID for the web app |
<!-- END_TF_DOCS -->