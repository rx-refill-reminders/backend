# stacks

Terragrunt stacks (`dev`, `prd`). Each stack directory contains:

- `stack.yml` — AWS account, assume-role ARN, and S3 state bucket (`states-bucket`)
- `env.hcl` — environment-specific values passed to units (e.g. domain)
- `<unit>/terragrunt.hcl` — deployable units

Shared config lives in [`root.hcl`](root.hcl), which reads `stack.yml` for the S3 backend (`use_lockfile = true`). Requires **Terraform >= 1.10** (GitHub `TERRAFORM_VERSION` variable).

State keys: `<stack>/<unit>/terraform.tfstate` (relative to `root.hcl`).

### Units

| Stack | Unit | Config |
|-------|------|--------|
| `prd` | `dns-tree` | [`prd/dns-tree/terragrunt.hcl`](prd/dns-tree/terragrunt.hcl) + [`prd/env.hcl`](prd/env.hcl) |

```bash
cd infra/stacks/prd/dns-tree
terragrunt plan
```
