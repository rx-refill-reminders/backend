# dns-hosted-zone

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.27.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.27.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm_cert"></a> [acm\_cert](#module\_acm\_cert) | ../dns-acm-certificate | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.delegated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone.existing_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_delegate_subdomain"></a> [delegate\_subdomain](#input\_delegate\_subdomain) | Delegate a subdomain to another hosted zone, if need be | <pre>object({<br/>    domain      = string<br/>    nameservers = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain name for the hosted zone | `any` | n/a | yes |
| <a name="input_use_existing_zone"></a> [use\_existing\_zone](#input\_use\_existing\_zone) | If true, searches for an existing hosted zone rather than creating a new one | `bool` | `false` | no |
| <a name="input_validate"></a> [validate](#input\_validate) | n/a | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | ACM certificate ARN for the root domain |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | Route53 name servers for the hosted zone |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The hosted zone ID |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | The hosted zone name |
<!-- END_TF_DOCS -->
