# Infrastructure (Terraform)

This directory contains all Infrastructure-as-Code for the Cloud Resume
Challenge project, implemented in Terraform (not SAM/CDK).

## Structure

```
infrastructure/
├── modules/
│   ├── presentation/   # S3 bucket, CloudFront distribution, ACM certificate
│   ├── logic/          # API Gateway, Lambda functions, Lambda IAM execution roles
│   └── data/           # DynamoDB table(s)
└── environments/
    └── prod/           # Root module wiring the three tier modules together
```

## Design Principles

- **Module isolation:** Each module under `modules/` exposes only
  `variables.tf` (inputs) and `outputs.tf` (outputs). Modules never
  reference each other directly.
- **Explicit wiring:** Cross-tier dependencies (e.g. the logic module
  needing the DynamoDB table name) are resolved in
  `environments/prod/main.tf`, which reads one module's outputs and
  passes them as another module's inputs.
- **No VPC:** This project deliberately does not use a VPC. All AWS
  services communicate via public/managed endpoints, secured with IAM
  auth. See [`docs/architecture/architecture-overview.md`](../docs/architecture/architecture-overview.md).
- **No long-lived credentials:** CI/CD (`.github/workflows/`)
  authenticates to AWS using OIDC-federated IAM roles.

## Usage

> Placeholder — commands will be finalized once the modules are
> implemented and a remote state backend is configured.

```bash
cd infrastructure/environments/prod
terraform init
terraform plan
terraform apply
```
