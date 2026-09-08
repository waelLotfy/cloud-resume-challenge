# Presentation Tier Module
#
# Provisions the static-hosting resources for the resume website:
#   - S3 bucket (origin for static assets)
#   - CloudFront distribution (CDN)
#   - ACM certificate (TLS for the custom domain)
#
# This module does not reference other tiers directly. All cross-tier
# wiring happens in infrastructure/environments/prod/main.tf.
#
# NOTE: This is a placeholder scaffold. Resource arguments must be
# completed once requirements (docs/requirements/) and the architecture
# (docs/architecture/architecture-overview.md) are finalized.

# TODO: aws_s3_bucket for static website assets
# resource "aws_s3_bucket" "site" {
# }

# TODO: aws_cloudfront_origin_access_control / origin access identity
# resource "aws_cloudfront_origin_access_control" "site" {
# }

# TODO: aws_cloudfront_distribution fronting the S3 bucket
# resource "aws_cloudfront_distribution" "site" {
# }

# TODO: aws_acm_certificate (validated via DNS, must be in us-east-1 for CloudFront)
# resource "aws_acm_certificate" "site" {
# }
