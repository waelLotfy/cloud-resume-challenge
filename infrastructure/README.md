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

## Local development: initializing the Terraform backend

Terraform state for `environments/prod` is stored remotely in S3. The backend
configuration in `environments/prod/backend.tf` intentionally omits the AWS
profile, because the correct value differs by environment:

- **Local development** authenticates with a named AWS CLI profile (AWS SSO).
- **CI (GitHub Actions)** authenticates through OIDC and receives temporary
  credentials from the environment. No profile exists on the runner.

The profile is therefore supplied at initialization time rather than stored
in code.

### Initialize locally

1. Authenticate with AWS SSO:

```powershell
   aws sso login --profile <your-aws-sso-profile>
```

2. Initialize Terraform from `infrastructure/environments/prod`:

```powershell
   terraform init -backend-config="profile=<your-aws-sso-profile>"
```

If backend settings have changed since the last initialization (for example,
a different profile or bucket), re-run with `-reconfigure`:

```powershell
terraform init -reconfigure -backend-config="profile=<your-aws-sso-profile>"
```

### Troubleshooting

| Error | Cause | Resolution |
|---|---|---|
| `InvalidClientTokenId` / `403` from STS | SSO session expired | Re-run `aws sso login` |
| `No valid credential sources found` | Profile not supplied at init | Re-run `terraform init` with `-backend-config="profile=..."` |
