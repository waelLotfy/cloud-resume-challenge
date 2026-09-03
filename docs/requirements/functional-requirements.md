# Functional Requirements

This document is the single source of truth for functional requirements
(FR1–FR25) of the Cloud Resume Challenge project. Each requirement must be
traceable to:

- An architecture element in [`docs/architecture/architecture-overview.md`](../architecture/architecture-overview.md)
- One or more acceptance criteria in [`docs/requirements/acceptance-criteria.md`](./acceptance-criteria.md)
- A GitHub Issue (see [`docs/traceability/README.md`](../traceability/README.md))
- Test(s) under `tests/` (unit, integration, and/or acceptance)

## Requirement ID Convention

- Functional requirements use the prefix `FR` followed by a sequential
  number, e.g. `FR1`, `FR2`, ... `FR25`.
- IDs are never reused or renumbered once assigned.
- Each requirement should reference the GitHub Issue tracking its
  implementation once created (e.g. `Tracked by #<issue-number>`).

## Requirement Template

Use the following template for each functional requirement:

```markdown
### FR<N>: <Short title>

- **Description:** <What the system must do>
- **Rationale:** <Why this requirement exists>
- **Tier/Component:** <Presentation | Logic | Data | Cross-cutting>
- **Related Architecture:** <link to architecture doc section>
- **Acceptance Criteria:** <link(s) to acceptance-criteria.md, or "Self-evident — no dedicated AC" if verification is trivial>
- **Tracked by:** #<issue-number>
- **Verification Method:** <Test | Analysis | Inspection | Demonstration>
```

## Functional Requirements

### FR1: Public resume access

- **Description:** The system shall display a resume to any visitor via a public URL.
- **Rationale:** The resume must be accessible to anyone (e.g. recruiters) without authentication.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** AC-FR4-1
- **Tracked by:** _TBD_
- **Verification Method:** E2E test

### FR2: Resume written in HTML

- **Description:** The resume shall be written in HTML.
- **Rationale:** HTML is the standard markup for web content served to browsers.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Manual inspection

### FR3: Resume styled with CSS

- **Description:** The resume shall be styled with CSS.
- **Rationale:** CSS provides visual presentation separate from content structure.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Manual inspection

### FR4: Static website hosting on S3

- **Description:** The resume shall be deployed online as an Amazon S3 static website.
- **Rationale:** S3 static hosting is a low-cost, highly available serverless hosting option.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** AC-FR4-1
- **Tracked by:** _TBD_
- **Verification Method:** E2E test

### FR5: HTTPS for the static website

- **Description:** The S3 static website shall use HTTPS for security.
- **Rationale:** HTTPS protects data in transit and is expected by modern browsers.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** AC-FR5-1, AC-FR5-2
- **Tracked by:** _TBD_
- **Verification Method:** E2E test

### FR6: CloudFront CDN distribution

- **Description:** The Amazon CloudFront shall be used.
- **Rationale:** CloudFront provides CDN/edge distribution, caching, and TLS termination for the site.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** AC-FR8-1
- **Tracked by:** _TBD_
- **Verification Method:** E2E test

### FR7: Custom DNS domain name

- **Description:** The site shall be reachable via a custom DNS domain name.
- **Rationale:** A custom domain provides a professional, memorable URL for the resume.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** AC-FR7-1
- **Tracked by:** _TBD_
- **Verification Method:** DNS/Network validation

### FR8: Domain pointed to CloudFront

- **Description:** The custom DNS domain name shall be pointed to the CloudFront distribution.
- **Rationale:** Ensures traffic to the custom domain is served via the CDN.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** AC-FR8-1
- **Tracked by:** _TBD_
- **Verification Method:** E2E test

### FR9: Route 53 as DNS provider

- **Description:** The Amazon Route 53 shall be used as the DNS provider.
- **Rationale:** Route 53 integrates natively with other AWS services (ACM, CloudFront) used in this architecture.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Manual inspection

### FR10: Visitor counter display

- **Description:** The resume webpage shall include a visitor counter that displays how many people have accessed the site.
- **Rationale:** Provides a simple, well-known dynamic feature demonstrating full-stack integration.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** AC-FR10-1, AC-FR10-2
- **Tracked by:** _TBD_
- **Verification Method:** E2E test

### FR11: Visitor counter implemented in JavaScript

- **Description:** The visitor counter shall be implemented in JavaScript.
- **Rationale:** JavaScript runs client-side in the browser to call the backend API and render the count.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Manual inspection

### FR12: DynamoDB stores visitor count

- **Description:** Amazon DynamoDB shall be used to retrieve and update the count of the visitor counter.
- **Rationale:** DynamoDB is a serverless, low-cost NoSQL data store suitable for a simple counter.
- **Tier/Component:** Data
- **Related Architecture:** [Data Tier](../architecture/architecture-overview.md#3-data-tier)
- **Acceptance Criteria:** AC-FR12-14-1, AC-FR12-14-2
- **Tracked by:** _TBD_
- **Verification Method:** Integration test

### FR13: No direct client-to-DynamoDB communication

- **Description:** There shall be no communication directly with DynamoDB from the JavaScript code.
- **Rationale:** Enforces separation of concerns and prevents exposing database credentials/access to the client.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Manual inspection

### FR14: API Gateway and Lambda mediate data access

- **Description:** AWS API Gateway and Lambda services shall be used for communication between the JavaScript code and DynamoDB.
- **Rationale:** Provides a controlled, serverless API layer between the frontend and the data store.
- **Tier/Component:** Logic
- **Related Architecture:** [Logic Tier](../architecture/architecture-overview.md#2-logic-tier)
- **Acceptance Criteria:** AC-FR12-14-1
- **Tracked by:** _TBD_
- **Verification Method:** Integration test

### FR15: Lambda function code in Python

- **Description:** The Lambda function code shall be written in Python.
- **Rationale:** Python is a widely supported Lambda runtime with strong AWS SDK (boto3) support.
- **Tier/Component:** Logic
- **Related Architecture:** [Logic Tier](../architecture/architecture-overview.md#2-logic-tier)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Manual inspection

### FR16: Automated tests for Lambda code

- **Description:** There shall be tests for the implemented Python code.
- **Rationale:** Automated tests validate backend correctness and prevent regressions.
- **Tier/Component:** Logic
- **Related Architecture:** [Logic Tier](../architecture/architecture-overview.md#2-logic-tier)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Manual inspection

### FR17: Infrastructure as Code for API resources

- **Description:** Infrastructure as Code shall be used for configuring the API resources, the DynamoDB table, the API Gateway, and the Lambda function.
- **Rationale:** IaC ensures reproducible, version-controlled infrastructure.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Manual inspection

### FR18: Terraform as the IaC tool

- **Description:** The infrastructure as code shall be Terraform.
- **Rationale:** Terraform is the chosen IaC tool for this project, providing declarative, provider-agnostic configuration.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Module Boundaries](../architecture/architecture-overview.md#module-boundaries)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Manual inspection

### FR19: Automated CI/CD for updates

- **Description:** Any update in the back-end API or the front-end website shall be done automatically through using CI/CD.
- **Rationale:** Automating deployments reduces manual error and enables fast, reliable delivery.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Demonstration

### FR20: Backend GitHub repository

- **Description:** A GitHub repository shall be created for the backend code.
- **Rationale:** Separates backend and frontend concerns, enabling independent versioning and pipelines.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Manual inspection

### FR21: CI/CD for backend code

- **Description:** GitHub Actions shall be set up for code implementation, tests, and deployment of the backend code.
- **Rationale:** Ensures the backend is automatically tested and deployed on changes.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** AC-FR21-1
- **Tracked by:** _TBD_
- **Verification Method:** Pipeline/CI validation

### FR22: Frontend GitHub repository

- **Description:** A second GitHub repository shall be created for the website code (frontend code).
- **Rationale:** Separates backend and frontend concerns, enabling independent versioning and pipelines.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Manual inspection

### FR23: CI/CD for frontend code

- **Description:** GitHub Actions shall be set up for code implementation, tests, and deployment of the frontend code (for example, when new website code is pushed, the S3 bucket automatically gets updated).
- **Rationale:** Ensures the frontend is automatically deployed to S3 on changes.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** AC-FR23-1
- **Tracked by:** _TBD_
- **Verification Method:** Pipeline/CI validation

### FR24: Automatic CloudFront cache invalidation

- **Description:** The CloudFront cache shall be invalidated automatically as part of the frontend CI/CD deployment (FR23).
- **Rationale:** Ensures visitors see the latest deployed content without stale cached assets.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** AC-FR24-1
- **Tracked by:** _TBD_
- **Verification Method:** Pipeline/CI validation

### FR25: Logging to CloudWatch

- **Description:** The system shall emit Lambda execution logs and API Gateway access logs to CloudWatch for troubleshooting and operational visibility.
- **Rationale:** Centralized logging supports debugging and operational monitoring.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** AC-FR25-1
- **Tracked by:** _TBD_
- **Verification Method:** Integration test

## Functional Requirements Register

| ID | Title | Tier/Component | Acceptance Criteria | Tracked by |
|----|-------|----------------|----------------------|------------|
| FR1 | Public resume access | Presentation | AC-FR4-1 | _TBD_ |
| FR2 | Resume written in HTML | Presentation | Self-evident — no dedicated AC | _TBD_ |
| FR3 | Resume styled with CSS | Presentation | Self-evident — no dedicated AC | _TBD_ |
| FR4 | Static website hosting on S3 | Presentation | AC-FR4-1 | _TBD_ |
| FR5 | HTTPS for the static website | Presentation | AC-FR5-1, AC-FR5-2 | _TBD_ |
| FR6 | CloudFront CDN distribution | Presentation | AC-FR8-1 | _TBD_ |
| FR7 | Custom DNS domain name | Presentation | AC-FR7-1 | _TBD_ |
| FR8 | Domain pointed to CloudFront | Presentation | AC-FR8-1 | _TBD_ |
| FR9 | Route 53 as DNS provider | Presentation | Self-evident — no dedicated AC | _TBD_ |
| FR10 | Visitor counter display | Presentation | AC-FR10-1, AC-FR10-2 | _TBD_ |
| FR11 | Visitor counter implemented in JavaScript | Presentation | Self-evident — no dedicated AC | _TBD_ |
| FR12 | DynamoDB stores visitor count | Data | AC-FR12-14-1, AC-FR12-14-2 | _TBD_ |
| FR13 | No direct client-to-DynamoDB communication | Cross-cutting | Self-evident — no dedicated AC | _TBD_ |
| FR14 | API Gateway and Lambda mediate data access | Logic | AC-FR12-14-1 | _TBD_ |
| FR15 | Lambda function code in Python | Logic | Self-evident — no dedicated AC | _TBD_ |
| FR16 | Automated tests for Lambda code | Logic | Self-evident — no dedicated AC | _TBD_ |
| FR17 | Infrastructure as Code for API resources | Cross-cutting | Self-evident — no dedicated AC | _TBD_ |
| FR18 | Terraform as the IaC tool | Cross-cutting | Self-evident — no dedicated AC | _TBD_ |
| FR19 | Automated CI/CD for updates | Cross-cutting | Self-evident — no dedicated AC | _TBD_ |
| FR20 | Backend GitHub repository | Cross-cutting | Self-evident — no dedicated AC | _TBD_ |
| FR21 | CI/CD for backend code | Cross-cutting | AC-FR21-1 | _TBD_ |
| FR22 | Frontend GitHub repository | Cross-cutting | Self-evident — no dedicated AC | _TBD_ |
| FR23 | CI/CD for frontend code | Cross-cutting | AC-FR23-1 | _TBD_ |
| FR24 | Automatic CloudFront cache invalidation | Cross-cutting | AC-FR24-1 | _TBD_ |
| FR25 | Logging to CloudWatch | Cross-cutting | AC-FR25-1 | _TBD_ |

---
_Sourced from the functional requirements defined in the public
[`cloud-resume-challenge`](https://github.com/waelLotfy/cloud-resume-challenge/blob/main/docs/01-Requirements/functional-requirements.md)
repository. Acceptance criteria and issue tracking links are to be filled
in as they are authored._
