# Input variables for the presentation module (S3, CloudFront, ACM).
#


#
variable "bucket_name" {
    description = "The name of the S3 bucket for static website assets."
    type        = string
}
# TODO: variable "domain_name" { type = string }
# TODO: variable "tags" { type = map(string) }
