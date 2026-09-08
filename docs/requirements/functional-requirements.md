# Functional Requirements

This document is the single source of truth for functional requirements
(FR1–FR25) of the Cloud Resume Challenge project. Each requirement must be
traceable to:

- An architecture element in [`docs/architecture/architecture-overview.md`](../architecture/architecture-overview.md)
- One or more acceptance criteria in [`docs/requirements/acceptance-criteria.md`](./acceptance-criteria.md)
- A GitHub Issue (see [`docs/traceability-matrix.md`](../traceability-matrix.md))
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
- **Acceptance Criteria:** [AC-FR4-1](./acceptance-criteria.md#ac-fr4-1-public-site-returns-resume)
- **Tracked by:** [#6](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/6)
- **Verification Method:** E2E test

### FR2: Resume written in HTML

- **Description:** The resume shall be written in HTML.
- **Rationale:** HTML is the standard markup for web content served to browsers.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** [#7](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/7)
- **Verification Method:** Manual inspection

### FR3: Resume styled with CSS

- **Description:** The resume shall be styled with CSS.
- **Rationale:** CSS provides visual presentation separate from content structure.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** [#8](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/8)
- **Verification Method:** Manual inspection

### FR4: Static website hosting on S3

- **Description:** The resume shall be deployed online as an Amazon S3 static website.
- **Rationale:** S3 static hosting is a low-cost, highly available serverless hosting option.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** [AC-FR4-1](./acceptance-criteria.md#ac-fr4-1-public-site-returns-resume)
- **Tracked by:** [#9](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/9)
- **Verification Method:** E2E test

### FR5: HTTPS for the static website

- **Description:** The S3 static website shall use HTTPS for security.
- **Rationale:** HTTPS protects data in transit and is expected by modern browsers.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** [AC-FR5-1](./acceptance-criteria.md#ac-fr5-1-http-redirects-to-https), [AC-FR5-2](./acceptance-criteria.md#ac-fr5-2-valid-tls-certificate)
- **Tracked by:** [#10](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/10)
- **Verification Method:** E2E test

### FR6: CloudFront CDN distribution

- **Description:** The Amazon CloudFront shall be used.
- **Rationale:** CloudFront provides CDN/edge distribution, caching, and TLS termination for the site.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** [AC-FR8-1](./acceptance-criteria.md#ac-fr8-1-custom-domain-served-via-cloudfront)
- **Tracked by:** [#11](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/11)
- **Verification Method:** E2E test

### FR7: Custom DNS domain name

- **Description:** The site shall be reachable via a custom DNS domain name.
- **Rationale:** A custom domain provides a professional, memorable URL for the resume.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** [AC-FR7-1](./acceptance-criteria.md#ac-fr7-1-custom-domain-resolves-to-cloudfront)
- **Tracked by:** [#12](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/12)
- **Verification Method:** DNS/Network validation

### FR8: Domain pointed to CloudFront

- **Description:** The custom DNS domain name shall be pointed to the CloudFront distribution.
- **Rationale:** Ensures traffic to the custom domain is served via the CDN.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** [AC-FR8-1](./acceptance-criteria.md#ac-fr8-1-custom-domain-served-via-cloudfront)
- **Tracked by:** [#13](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/13)
- **Verification Method:** E2E test

### FR9: Route 53 as DNS provider

- **Description:** The Amazon Route 53 shall be used as the DNS provider.
- **Rationale:** Route 53 integrates natively with other AWS services (ACM, CloudFront) used in this architecture.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** [#14](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/14)
- **Verification Method:** Manual inspection

### FR10: Visitor counter display

- **Description:** The resume webpage shall include a visitor counter that displays how many people have accessed the site.
- **Rationale:** Provides a simple, well-known dynamic feature demonstrating full-stack integration.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** [AC-FR10-1](./acceptance-criteria.md#ac-fr10-1-visitor-counter-displays-on-load), [AC-FR10-2](./acceptance-criteria.md#ac-fr10-2-visitor-counter-increments-on-refresh)
- **Tracked by:** [#15](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/15)
- **Verification Method:** E2E test

### FR11: Visitor counter implemented in JavaScript

- **Description:** The visitor counter shall be implemented in JavaScript.
- **Rationale:** JavaScript runs client-side in the browser to call the backend API and render the count.
- **Tier/Component:** Presentation
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** [#16](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/16)
- **Verification Method:** Manual inspection

### FR12: DynamoDB stores visitor count

- **Description:** Amazon DynamoDB shall be used to retrieve and update the count of the visitor counter.
- **Rationale:** DynamoDB is a serverless, low-cost NoSQL data store suitable for a simple counter.
- **Tier/Component:** Data
- **Related Architecture:** [Data Tier](../architecture/architecture-overview.md#3-data-tier)
- **Acceptance Criteria:** [AC-FR12-14-1](./acceptance-criteria.md#ac-fr12-14-1-api-returns-and-increments-visitor-count), [AC-FR12-14-2](./acceptance-criteria.md#ac-fr12-14-2-lambda-handler-logic-mocked)
- **Tracked by:** [#17](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/17)
- **Verification Method:** Integration test

### FR13: No direct client-to-DynamoDB communication

- **Description:** There shall be no communication directly with DynamoDB from the JavaScript code.
- **Rationale:** Enforces separation of concerns and prevents exposing database credentials/access to the client.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** [#18](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/18)
- **Verification Method:** Manual inspection

### FR14: API Gateway and Lambda mediate data access

- **Description:** AWS API Gateway and Lambda services shall be used for communication between the JavaScript code and DynamoDB.
- **Rationale:** Provides a controlled, serverless API layer between the frontend and the data store.
- **Tier/Component:** Logic
- **Related Architecture:** [Logic Tier](../architecture/architecture-overview.md#2-logic-tier)
- **Acceptance Criteria:** [AC-FR12-14-1](./acceptance-criteria.md#ac-fr12-14-1-api-returns-and-increments-visitor-count)
- **Tracked by:** [#19](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/19)
- **Verification Method:** Integration test

### FR15: Lambda function code in Python

- **Description:** The Lambda function code shall be written in Python.
- **Rationale:** Python is a widely supported Lambda runtime with strong AWS SDK (boto3) support.
- **Tier/Component:** Logic
- **Related Architecture:** [Logic Tier](../architecture/architecture-overview.md#2-logic-tier)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** [#20](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/20)
- **Verification Method:** Manual inspection

### FR16: Automated tests for Lambda code

- **Description:** There shall be tests for the implemented Python code.
- **Rationale:** Automated tests validate backend correctness and prevent regressions.
- **Tier/Component:** Logic
- **Related Architecture:** [Logic Tier](../architecture/architecture-overview.md#2-logic-tier)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** [#21](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/21)
- **Verification Method:** Manual inspection

### FR17: Infrastructure as Code for API resources

- **Description:** Infrastructure as Code shall be used for configuring the API resources, the DynamoDB table, the API Gateway, and the Lambda function.
- **Rationale:** IaC ensures reproducible, version-controlled infrastructure.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** [#22](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/22)
- **Verification Method:** Manual inspection

### FR18: Terraform as the IaC tool

- **Description:** The infrastructure as code shall be Terraform.
- **Rationale:** Terraform is the chosen IaC tool for this project, providing declarative, provider-agnostic configuration.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** [#23](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/23)
- **Verification Method:** Manual inspection

### FR19: Automated CI/CD for updates

- **Description:** Any update in the back-end API or the front-end website shall be done automatically through using CI/CD.
- **Rationale:** Automating deployments reduces manual error and enables fast, reliable delivery.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** [#24](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/24)
- **Verification Method:** Demonstration

### FR20: Backend GitHub repository

- **Description:** A GitHub repository shall be created for the backend code.
- **Rationale:** Separates backend and frontend concerns, enabling independent versioning and pipelines.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** [#25](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/25)
- **Verification Method:** Manual inspection

### FR21: CI/CD for backend code

- **Description:** GitHub Actions shall be set up for code implementation, tests, and deployment of the backend code.
- **Rationale:** Ensures the backend is automatically tested and deployed on changes.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** [AC-FR21-1](./acceptance-criteria.md#ac-fr21-1-backend-cicd-pipeline-succeeds)
- **Tracked by:** [#26](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/26)
- **Verification Method:** Pipeline/CI validation

### FR22: Frontend GitHub repository

- **Description:** A second GitHub repository shall be created for the website code (frontend code).
- **Rationale:** Separates backend and frontend concerns, enabling independent versioning and pipelines.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** [#27](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/27)
- **Verification Method:** Manual inspection

### FR23: CI/CD for frontend code

- **Description:** GitHub Actions shall be set up for code implementation, tests, and deployment of the frontend code (for example, when new website code is pushed, the S3 bucket automatically gets updated).
- **Rationale:** Ensures the frontend is automatically deployed to S3 on changes.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** [AC-FR23-1](./acceptance-criteria.md#ac-fr23-1-frontend-cicd-pipeline-succeeds)
- **Tracked by:** [#28](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/28)
- **Verification Method:** Pipeline/CI validation

### FR24: Automatic CloudFront cache invalidation

- **Description:** The CloudFront cache shall be invalidated automatically as part of the frontend CI/CD deployment (FR23).
- **Rationale:** Ensures visitors see the latest deployed content without stale cached assets.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** [AC-FR24-1](./acceptance-criteria.md#ac-fr24-1-cloudfront-cache-invalidation-triggered)
- **Tracked by:** [#29](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/29)
- **Verification Method:** Pipeline/CI validation

### FR25: Logging to CloudWatch

- **Description:** The system shall emit Lambda execution logs and API Gateway access logs to CloudWatch for troubleshooting and operational visibility.
- **Rationale:** Centralized logging supports debugging and operational monitoring.
- **Tier/Component:** Cross-cutting
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** [AC-FR25-1](./acceptance-criteria.md#ac-fr25-1-lambda-invocation-logged-to-cloudwatch)
- **Tracked by:** [#30](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/30)
- **Verification Method:** Integration test

## Functional Requirements Register

| ID | Title | Tier/Component | Acceptance Criteria | Tracked by |
|----|-------|----------------|----------------------|------------|
| [FR1](#fr1-public-resume-access) | Public resume access | Presentation | [AC-FR4-1](./acceptance-criteria.md#ac-fr4-1-public-site-returns-resume) | [#6](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/6) |
| [FR2](#fr2-resume-written-in-html) | Resume written in HTML | Presentation | Self-evident — no dedicated AC | [#7](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/7) |
| [FR3](#fr3-resume-styled-with-css) | Resume styled with CSS | Presentation | Self-evident — no dedicated AC | [#8](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/8) |
| [FR4](#fr4-static-website-hosting-on-s3) | Static website hosting on S3 | Presentation | [AC-FR4-1](./acceptance-criteria.md#ac-fr4-1-public-site-returns-resume) | [#9](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/9) |
| [FR5](#fr5-https-for-the-static-website) | HTTPS for the static website | Presentation | [AC-FR5-1](./acceptance-criteria.md#ac-fr5-1-http-redirects-to-https), [AC-FR5-2](./acceptance-criteria.md#ac-fr5-2-valid-tls-certificate) | [#10](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/10) |
| [FR6](#fr6-cloudfront-cdn-distribution) | CloudFront CDN distribution | Presentation | [AC-FR8-1](./acceptance-criteria.md#ac-fr8-1-custom-domain-served-via-cloudfront) | [#11](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/11) |
| [FR7](#fr7-custom-dns-domain-name) | Custom DNS domain name | Presentation | [AC-FR7-1](./acceptance-criteria.md#ac-fr7-1-custom-domain-resolves-to-cloudfront) | [#12](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/12) |
| [FR8](#fr8-domain-pointed-to-cloudfront) | Domain pointed to CloudFront | Presentation | [AC-FR8-1](./acceptance-criteria.md#ac-fr8-1-custom-domain-served-via-cloudfront) | [#13](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/13) |
| [FR9](#fr9-route-53-as-dns-provider) | Route 53 as DNS provider | Presentation | Self-evident — no dedicated AC | [#14](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/14) |
| [FR10](#fr10-visitor-counter-display) | Visitor counter display | Presentation | [AC-FR10-1](./acceptance-criteria.md#ac-fr10-1-visitor-counter-displays-on-load), [AC-FR10-2](./acceptance-criteria.md#ac-fr10-2-visitor-counter-increments-on-refresh) | [#15](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/15) |
| [FR11](#fr11-visitor-counter-implemented-in-javascript) | Visitor counter implemented in JavaScript | Presentation | Self-evident — no dedicated AC | [#16](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/16) |
| [FR12](#fr12-dynamodb-stores-visitor-count) | DynamoDB stores visitor count | Data | [AC-FR12-14-1](./acceptance-criteria.md#ac-fr12-14-1-api-returns-and-increments-visitor-count), [AC-FR12-14-2](./acceptance-criteria.md#ac-fr12-14-2-lambda-handler-logic-mocked) | [#17](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/17) |
| [FR13](#fr13-no-direct-client-to-dynamodb-communication) | No direct client-to-DynamoDB communication | Cross-cutting | Self-evident — no dedicated AC | [#18](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/18) |
| [FR14](#fr14-api-gateway-and-lambda-mediate-data-access) | API Gateway and Lambda mediate data access | Logic | [AC-FR12-14-1](./acceptance-criteria.md#ac-fr12-14-1-api-returns-and-increments-visitor-count) | [#19](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/19) |
| [FR15](#fr15-lambda-function-code-in-python) | Lambda function code in Python | Logic | Self-evident — no dedicated AC | [#20](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/20) |
| [FR16](#fr16-automated-tests-for-lambda-code) | Automated tests for Lambda code | Logic | Self-evident — no dedicated AC | [#21](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/21) |
| [FR17](#fr17-infrastructure-as-code-for-api-resources) | Infrastructure as Code for API resources | Cross-cutting | Self-evident — no dedicated AC | [#22](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/22) |
| [FR18](#fr18-terraform-as-the-iac-tool) | Terraform as the IaC tool | Cross-cutting | Self-evident — no dedicated AC | [#23](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/23) |
| [FR19](#fr19-automated-cicd-for-updates) | Automated CI/CD for updates | Cross-cutting | Self-evident — no dedicated AC | [#24](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/24) |
| [FR20](#fr20-backend-github-repository) | Backend GitHub repository | Cross-cutting | Self-evident — no dedicated AC | [#25](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/25) |
| [FR21](#fr21-cicd-for-backend-code) | CI/CD for backend code | Cross-cutting | [AC-FR21-1](./acceptance-criteria.md#ac-fr21-1-backend-cicd-pipeline-succeeds) | [#26](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/26) |
| [FR22](#fr22-frontend-github-repository) | Frontend GitHub repository | Cross-cutting | Self-evident — no dedicated AC | [#27](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/27) |
| [FR23](#fr23-cicd-for-frontend-code) | CI/CD for frontend code | Cross-cutting | [AC-FR23-1](./acceptance-criteria.md#ac-fr23-1-frontend-cicd-pipeline-succeeds) | [#28](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/28) |
| [FR24](#fr24-automatic-cloudfront-cache-invalidation) | Automatic CloudFront cache invalidation | Cross-cutting | [AC-FR24-1](./acceptance-criteria.md#ac-fr24-1-cloudfront-cache-invalidation-triggered) | [#29](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/29) |
| [FR25](#fr25-logging-to-cloudwatch) | Logging to CloudWatch | Cross-cutting | [AC-FR25-1](./acceptance-criteria.md#ac-fr25-1-lambda-invocation-logged-to-cloudwatch) | [#30](https://github.com/waelLotfy/cloud-resume-challenge-private/issues/30) |

---
