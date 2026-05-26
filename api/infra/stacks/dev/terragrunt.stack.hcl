locals {
  stack_config = yamldecode(file("${get_terragrunt_dir()}/stack.yml"))
}

unit "lambda_function" {
  source = "${get_repo_root()}/api/infra/units/lambda-function"
  path   = "lambda-function"

  values = {
    function_name   = "backend-api-handler"
    handler         = "bootstrap"
    dist_path       = "${get_repo_root()}/api/src/dist"
    code_bucket_id  = "lambda-source-code-339284817422-us-east-1-an"
    role_arn        = "arn:aws:iam::339284817422:role/lambda-api"
    runtime         = "provided.al2023"
    timeout_seconds = 30
  }
}
