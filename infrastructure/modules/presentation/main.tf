terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.36.0"
    }
  }
}
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

# aws_s3_bucket for static website assets
resource "aws_s3_bucket" "resume_site" {
  # The bucket name is NOT hardcoded.
  # It comes from the module input variable "bucket_name",
  # which the root module provides (prod, dev, staging, etc.)
  bucket = var.bucket_name
  tags = var.tags
}

# --------------------------------------------------------------------
# Block ALL public access to the bucket (the security guard at the door)
# --------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "resume_site_block" {
  # Attach this public-access-block to the bucket we just created.
  # It is as if assigning the security guard to the storage room.
  bucket                  = aws_s3_bucket.resume_site.id

  # Prevent anyone from making the bucket public using ACLs.
  # ACLs are an old permission system — we disable them completely.
  block_public_acls = true

  # Prevent bucket policies that try to make the bucket public.
  # Even if someone writes a policy that exposes the bucket,
  # this setting blocks it.
  block_public_policy = true

  # Ignore any ACLs that attempt to make objects public.
  # If someone tries to add a public ACL, Terraform/AWS will ignore it.
  ignore_public_acls = true

  # Do not allow this bucket to EVER become public.
  # This is the strongest protection — the bucket stays private forever.
  restrict_public_buckets = true

}

# Origin Access Control - lets Cloudfront authenticate to the private bucket S3
resource "aws_cloudfront_origin_access_control" "resume_oac" {
  # A human‑readable name for the OAC. Appears in the AWS console.
  name                              = "resume-site-oac"

  description                       = "Origin Access Control for CloudFront to access S3 bucket"

  # Specifies that this OAC is used for an S3 origin.
  # CloudFront will use this identity when sending requests to S3.
  origin_access_control_origin_type = "s3"

  # Ensures CloudFront ALWAYS signs requests sent to S3.
  # Without signing, S3 would reject the request because the bucket is private.
  signing_behavior                  = "always"

  # Uses AWS Signature Version 4 (SigV4) for request signing.
  # This is the modern, secure signing protocol used across AWS.
  signing_protocol                  = "sigv4"
}

# --------------------------------------------------------------------
# The CloudFront distribution itself
# Global Content Delivery Network (CDN) to serve content over HTTPS from edge caches.
# --------------------------------------------------------------------
   resource "aws_cloudfront_distribution" "resume_cdn" {
        # The origin is the S3 bucket we created earlier.
        origin {
        domain_name = aws_s3_bucket.resume_site.bucket_regional_domain_name # Use the regional domain name for S3 (not the website endpoint)
        origin_id   = "s3-resume-site" # Unique identifier for this origin within the distribution

        # Use the Origin Access Control we just created.
        origin_access_control_id = aws_cloudfront_origin_access_control.resume_oac.id # This tells CloudFront to use the OAC when accessing the S3 bucket, allowing it to authenticate and fetch private content.
        }

        # Default cache behavior for requests to the distribution.
        default_cache_behavior {
        allowed_methods  = ["GET", "HEAD"] # Only allow GET and HEAD requests to the distribution. Other methods (POST, PUT, DELETE) are not allowed for static content.
        cached_methods   = ["GET", "HEAD"] # Only cache GET and HEAD requests. Other methods are not cached.
        target_origin_id = "s3-resume-site" # This must match the origin_id of the origin block

         viewer_protocol_policy = "redirect-to-https" # Redirect all HTTP requests to HTTPS for security.

          # Forwarded values configuration for the cache behavior. This controls what query strings and cookies are forwarded to the origin (S3 bucket).
          forwarded_values {
            query_string = false # Do not forward query strings to the origin. This means that requests with query parameters will be treated the same as those without.
            cookies {
              forward = "none"  # Do not forward cookies to the origin. This means that requests with cookies will be treated the same as those without.
            }
          }

        }


        viewer_certificate {
        cloudfront_default_certificate = true # Use the default CloudFront certificate (for *.cloudfront.net domains). For custom domains, you would use an ACM certificate here.
        }


        enabled             = true # Activates the distribution upon deployment (set to false to stage without enabling traffic)
        is_ipv6_enabled     = true # Enable IPv6 support for the distribution, as setting it to true makes the distribution also reachable over IPv6, so visitors on IPv6-only networks (increasingly common on mobile carriers) can reach the resume.
        comment             = "CloudFront distribution for resume site" # A human-readable comment for the distribution, useful for identifying it in the AWS console.
        default_root_object = "index.html" # The object returned when a user requests the root domain URL (e.g., example.com/)
        price_class = "PriceClass_100" # Use the lowest-cost edge locations (US, Canada, Europe)


        restrictions {
        geo_restriction {
            restriction_type = "none" # No geographic restrictions; the distribution is accessible from anywhere in the world.
        }
        }

        tags = var.tags # Apply tags to the distribution for cost allocation and resource management. The tags are provided via the module input variable "tags", which allows the root module to define them.
   }

# --------------------------------------------------------------------
# Bucket policy: allow ONLY this specific CloudFront distribution to read objects
# --------------------------------------------------------------------
resource "aws_s3_bucket_policy" "resume_site_cf_policy" {
  bucket = aws_s3_bucket.resume_site.id # The bucket to which this policy applies (the S3 bucket we created earlier).
  # The policy is defined in JSON format. It allows the CloudFront Origin Access Control (OAC) to perform the GetObject action on all objects in the bucket, effectively granting read access only to CloudFront while keeping the bucket private from all other principals.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowCloudFrontServicePrincipal" # A unique identifier for this statement
        Effect = "Allow" # Allow the following action
        Principal = {
          Service = "cloudfront.amazonaws.com" # The principal is the CloudFront service itself, which will be allowed to access the bucket
        }
        Action = "s3:GetObject" # Allow the GetObject action (read access)
        Resource = "${aws_s3_bucket.resume_site.arn}/*" # Apply this policy to all objects in the bucket
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.resume_cdn.arn # Restrict access to requests originating from the specific CloudFront distribution we created
          }
        }
      }
    ]
  })
}
# TODO: aws_acm_certificate (validated via DNS, must be in us-east-1 for CloudFront)
# resource "aws_acm_certificate" "site" {
# }
