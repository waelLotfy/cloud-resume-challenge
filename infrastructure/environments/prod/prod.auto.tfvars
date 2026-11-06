# Example tfvars file for the "prod" environment.
# Copy to terraform.tfvars (which is gitignored) and fill in real values.
#


aws_region = "eu-central-1" # Frankfurt region

bucket_name = "wael-cloud-resume-2026"
# domain_name = "<TBD>"

tags = {
  Project     = "cloud-resume-challenge"
  Environment = "prod"
  ManagedBy   = "terraform"
}

table_name = "wael-cloud-resume-visitor-count"

github_repo_immutable = "waelLotfy@74569844/cloud-resume-challenge@1353849887"