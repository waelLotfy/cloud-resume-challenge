# Input variables for the data module (DynamoDB).


variable "table_name" {
  description = "Name of the DynamoDB table storing the visitor count."
  type = string
}
variable "billing_mode" {
  description = "The billing mode for the DynamoDB table."
  type = string
  default = "PAY_PER_REQUEST" # Billing mode — PAY_PER_REQUEST: Terraform's name "on-demand pricing." as the pay per read/write actually performed, no pre-provisioned capacity to size or guess at. For a resume counter, this is the only sensible choice — essentially free at your traffic volume.
}
variable "tags" {
  description = "A map of tags to assign to the DynamoDB table."
  type = map(string)
  default = {}
}
