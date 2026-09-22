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
}

# TODO: module "data" {
#   source = "../../modules/data"
#   # ...
# }

# TODO: module "logic" {
#   source = "../../modules/logic"
#   dynamodb_table_name = module.data.table_name
#   dynamodb_table_arn  = module.data.table_arn
#   # ...
# }
