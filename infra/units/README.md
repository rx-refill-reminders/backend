# units

Terragrunt unit templates — referenced by `source` in each stack’s `terragrunt.stack.hcl`. Terragrunt generates runnable units under `<stack>/.terragrunt-stack/`.

| Unit | Module |
|------|--------|
| `dns-hosted-zone` | [`modules/dns-hosted-zone`](../modules/dns-hosted-zone) |
| `cognito-user-pool` | [`modules/cognito-user-pool`](../modules/cognito-user-pool) |
