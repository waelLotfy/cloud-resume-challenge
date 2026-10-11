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
  default     = null
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
}

variable "table_name" {
  description = "Name of the DynamoDB table storing the visitor count."
  type        = string
}

variable "github_repo_immutable" {
  description = "Immutable-ID form of the repository (owner@ownerId/name@repoId) used in OIDC subject claims when the repo's sub claim uses immutable IDs"
  type        = string
}