# api-gateway

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
| <a name="module_api_cert"></a> [api\_cert](#module\_api\_cert) | ../dns-acm-certificate | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_api_mapping.mapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api_mapping) | resource |
| [aws_apigatewayv2_domain_name.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name) | resource |
| [aws_apigatewayv2_stage.stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |
| [aws_cloudwatch_log_group.gateway_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_route53_record.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | Custom domain for the API (ACM cert, API Gateway domain, Route53 alias). Omit for execute-api URL only. | <pre>object({<br/>    zone_id  = string<br/>    hostname = string<br/>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | API Gateway name (also used for the stage and CloudWatch log group path) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_hostname"></a> [api\_hostname](#output\_api\_hostname) | Custom API hostname (null when domain is not configured) |
| <a name="output_api_url"></a> [api\_url](#output\_api\_url) | Public HTTPS URL for the API custom domain (null when domain is not configured) |
| <a name="output_custom_domain_name"></a> [custom\_domain\_name](#output\_custom\_domain\_name) | API Gateway custom domain name resource ID (null when domain is not configured) |
| <a name="output_gateway_arn"></a> [gateway\_arn](#output\_gateway\_arn) | n/a |
| <a name="output_gateway_execution_arn"></a> [gateway\_execution\_arn](#output\_gateway\_execution\_arn) | n/a |
| <a name="output_gateway_id"></a> [gateway\_id](#output\_gateway\_id) | n/a |
| <a name="output_stage_arn"></a> [stage\_arn](#output\_stage\_arn) | n/a |
| <a name="output_stage_url"></a> [stage\_url](#output\_stage\_url) | n/a |
<!-- END_TF_DOCS -->
