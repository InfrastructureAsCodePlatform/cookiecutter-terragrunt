terraform {
  source = "{{cookiecutter.__terraform_module_version}}"
}

inputs = {
  repository = "{{cookiecutter.github_repository}}"
  secrets    = {{cookiecutter.github_secrets}}
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "{{cookiecutter.aws_region}}"
}
provider "github" {
  token = "{{cookiecutter.github_token}}"
}

EOF
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "{{cookiecutter.project}}-{{cookiecutter.aws_region}}-{{cookiecutter.environment}}-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "{{cookiecutter.aws_region}}"
    dynamodb_table = "{{cookiecutter.project}}-{{cookiecutter.aws_region}}-{{cookiecutter.environment}}-terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
