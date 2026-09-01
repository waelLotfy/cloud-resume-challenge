# Non-functional Requirements

- **NFR1 (Availability):** The resume website shall be highly available (S3 + CloudFront gives this near-free).
- **NFR2 (Cost):** The system shall run within AWS Free Tier for low traffic.
- **NFR3 (Security):** No public writing access to the database; API should not allow arbitrary writes; least-privilege IAM roles.
- **NFR4 (Security):** DO NOT commit AWS credentials to source control.
- **NFR5 (Maintainability):** Infrastructure defined as code (Terraform), not manually clicked in the console.
- **NFR6 (CI/CD):** Frontend and backend should each auto-deploy on push to their respective GitHub repos, gated by passing tests.
- **NFR7 (Testability):** Backend logic (Lambda) shall have automated unit tests; infrastructure changes shall be validated before deploying.
- **NFR8(Security):** The CI/CD pipeline shall authenticate to AWS using short-lived credentials obtained via IAM OIDC federation with GitHub Actions, rather than long-lived IAM access keys.
- **NFR9(Cost):** A CloudWatch billing alarm shall be configured to alert if AWS costs exceed a defined threshold, to prevent unexpected charges during development.
