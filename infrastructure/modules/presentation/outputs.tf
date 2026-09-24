# Outputs exposed by the presentation module for use by the environment
# root module (infrastructure/environments/prod/main.tf). Other modules
# must not consume these directly.
#


# ---------------------------------------------------------
# Expose the bucket's ID so the root module or other modules
# can reference this bucket later (e.g., CloudFront origin).
# It is as if giving the bucket a "serial number".
# ---------------------------------------------------------
output "bucket_id" {
  value = aws_s3_bucket.resume_site.id
}

# ---------------------------------------------------------
# Expose the bucket's ARN (Amazon Resource Name).
# This is the bucket's "full legal identity" in AWS.
# Many AWS services require the ARN for permissions.
# ---------------------------------------------------------
output "bucket_arn" {
  value = aws_s3_bucket.resume_site.arn
}
output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.resume_cdn.id
}
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.resume_cdn.domain_name
}
# TODO: output "acm_certificate_arn" { value = ... }
