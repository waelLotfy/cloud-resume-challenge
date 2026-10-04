variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "aws_profile" {
  description = "The AWS profile to use"
  type        = string
}

variable "state_bucket_name" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {}
}

variable "authorized_principal_arns" {
  description = "IAM ARNs allowed to read/write Terraform state - your own user/role now, plus the GitHub Actions OIDC role once created."
  type        = list(string)
}