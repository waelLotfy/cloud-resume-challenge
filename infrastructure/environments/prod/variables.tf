# Input variables for the "prod" environment root module.
#


variable "aws_region" {
  type = string
}

# The AWS CLI profile name that Terraform should use for authentication.
# This must match the profile defined in ~/.aws/config
# Example: [profile cloud-resume-project]
variable "aws_profile" {
  description = "AWS CLI profile name for SSO authentication"
  type        = string
}

# ---------------------------------------------------------
# Root-level variable declaration
# The root module needs its own copy of "bucket_name"
# so it can receive a real value and pass it to the module.
# ---------------------------------------------------------
variable "bucket_name" {
  type = string
}
# TODO: variable "domain_name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}

variable "table_name" {
  description = "Name of the DynamoDB table storing the visitor count."
  type = string
}

variable "github_repo" {
  description = "GitHub repo in owner/name form, used to scope the OIDC trust policy."
  type        = string
}