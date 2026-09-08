# Root module for the "prod" environment.
#
# Wires together the three tier modules explicitly. Modules do not
# reference each other directly — any values a module needs from another
# tier are read from that module's outputs here and passed in as inputs.
#
# NOTE: This is a placeholder scaffold. Module calls must be completed
# once requirements (docs/requirements/) and the architecture
# (docs/architecture/architecture-overview.md) are finalized.

# TODO: module "presentation" {
#   source = "../../modules/presentation"
#   # ...
# }

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
