# Root module for the "prod" environment.
#
# Wires together the three tier modules explicitly. Modules do not
# reference each other directly — any values a module needs from another
# tier are read from that module's outputs here and passed in as inputs.
#
# ---------------------------------------------------------
# Call the presentation module
# Pass the bucket_name variable down to the module.
# ---------------------------------------------------------
module "presentation" {

  source = "../../modules/presentation"
  # The root module provides the actual bucket name.
  # This value flows into the module's variable "bucket_name".
  bucket_name = var.bucket_name
  tags = var.tags
}

module "data" {
  source = "../../modules/data"
  # The root module provides the actual table name.
  # This value flows into the module's variable "table_name".
  table_name = var.table_name
  tags = var.tags
}

module "logic" {
   source = "../../modules/logic" # The root module provides the actual table name and ARN.
   table_name = module.data.table_name
   table_arn  = module.data.table_arn
   tags = var.tags
}

module "cicd" {
  source = "../../modules/cicd"

  github_repo   = var.github_repo
  github_branch = "main"

  state_bucket_arn = "arn:aws:s3:::wael-crc-terraform-state"
  resume_bucket_arn = module.presentation.resume_bucket_arn
  cloudfront_distribution_arn = module.presentation.cloudfront_distribution_arn
  dynamodb_table_arn = module.data.table_arn
  lambda_function_arns = [
    module.logic.get_visitor_count_function_arn,
    module.logic.increment_visitor_count_function_arn,
  ]
  lambda_execution_role_arns = [
    module.logic.get_visitor_count_role_arn,
    module.logic.increment_visitor_count_role_arn,
  ]
  api_gateway_execution_arn = module.logic.api_gateway_execution_arn
  tags = var.tags
}