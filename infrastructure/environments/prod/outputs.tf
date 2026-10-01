# Outputs for the "prod" environment root module.
#

# TODO: output "cloudfront_domain_name" { value = module.presentation.cloudfront_domain_name }
# Re-export the API Gateway's base URL from the logic module,
# so it's visible via `terraform output` at the root level -
# needed for Postman testing now, and for the frontend's main.js later.
output "api_endpoint" {
  value = module.logic.api_endpoint
}
