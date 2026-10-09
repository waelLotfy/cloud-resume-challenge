variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "github_repo" {
  description = "The GitHub repository in the format owner/name form, e.g., waelLotfy/cloud-resume-challenge-private"
  type        = string
}

variable "github_branch" {
  description = "The GitHub branch allowed to assume this role"
  type        = string
  default     = "main"
}

variable "state_bucket_arn" {
  description = "The ARN of the S3 bucket used for Terraform state"
  type        = string
}

variable "resume_bucket_arn" {
  description = "The ARN of the S3 bucket used for the resume content"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table used for visitor count"
  type        = string
}

variable "lambda_function_arns" {
  description = "The ARNs of the Lambda functions used for visitor count"
  type        = list(string)
}

variable "lambda_execution_role_arns" {
  description = "The ARNs of the Lambda execution roles used for visitor count"
  type        = list(string)
}

variable "api_gateway_execution_arn" {
  description = "The ARN of the API Gateway execution role used for visitor count"
  type        = string
}

variable "state_lock_key" {
  description = "Object key of the Terraform state lock file, used to scope the plan role's write access to exactly that one object."
  type        = string
  default     = "prod/terraform.tfstate.tflock"

}