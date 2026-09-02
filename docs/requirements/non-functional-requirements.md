# Non-Functional Requirements

This document is the single source of truth for non-functional
requirements (NFR1–NFR9) of the Cloud Resume Challenge project — covering
qualities such as performance, security, availability, cost, and
maintainability rather than specific features.

## Requirement ID Convention

- Non-functional requirements use the prefix `NFR` followed by a
  sequential number, e.g. `NFR1`, `NFR2`, ... `NFR9`.
- IDs are never reused or renumbered once assigned.
- Each requirement should reference the GitHub Issue tracking its
  implementation once created (e.g. `Tracked by #<issue-number>`).

## Requirement Template

Use the following template for each non-functional requirement:

```markdown
### NFR<N>: <Short title>

- **Category:** <Performance | Security | Availability | Cost | Maintainability | Usability | Compliance>
- **Description:** <The quality attribute the system must exhibit>
- **Rationale:** <Why this requirement exists>
- **Related Architecture:** <link to architecture doc section>
- **Acceptance Criteria:** <link(s) to acceptance-criteria.md>
- **Tracked by:** #<issue-number>
- **Verification Method:** <Test | Analysis | Inspection | Demonstration>
```

## Non-Functional Requirements

### NFR1: High availability

- **Category:** Availability
- **Description:** The resume website shall be highly available (S3 + CloudFront gives this near-free).
- **Rationale:** A resume site should be reachable at all times, since it may be viewed by recruiters at any moment.
- **Related Architecture:** [Presentation Tier](../architecture/architecture-overview.md#1-presentation-tier)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Demonstration

### NFR2: Free Tier cost constraint

- **Category:** Cost
- **Description:** The system shall run within AWS Free Tier for low traffic.
- **Rationale:** Keeps operating costs at (or near) zero during development and low-traffic usage.
- **Related Architecture:** [Style](../architecture/architecture-overview.md#style)
- **Acceptance Criteria:** AC-NFR2-1
- **Tracked by:** _TBD_
- **Verification Method:** Analysis

### NFR3: No public write access to data

- **Category:** Security
- **Description:** No public writing access to the database; API should not allow arbitrary writes; least-privilege IAM roles.
- **Rationale:** Prevents abuse or tampering of the visitor counter and other application state.
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Inspection

### NFR4: No credentials in source control

- **Category:** Security
- **Description:** AWS credentials shall not be committed to source control.
- **Rationale:** Prevents credential leakage and unauthorized AWS account access.
- **Related Architecture:** [Explicit Non-Goals](../architecture/architecture-overview.md#explicit-non-goals)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Inspection

### NFR5: Infrastructure as Code

- **Category:** Maintainability
- **Description:** Infrastructure shall be defined as code (Terraform), not manually clicked in the console.
- **Rationale:** Ensures reproducibility, version control, and peer review of infrastructure changes.
- **Related Architecture:** [Module Boundaries](../architecture/architecture-overview.md#module-boundaries)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Inspection

### NFR6: Gated CI/CD auto-deploy

- **Category:** Maintainability
- **Description:** Frontend and backend shall each auto-deploy on push to their respective GitHub repos, gated by passing tests.
- **Rationale:** Ensures only validated code reaches production while keeping deployments automated.
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Demonstration

### NFR7: Automated backend testing

- **Category:** Maintainability
- **Description:** Backend logic (Lambda) shall have automated unit tests; infrastructure changes shall be validated before deploying.
- **Rationale:** Reduces regressions and catches issues before they reach production.
- **Related Architecture:** [Logic Tier](../architecture/architecture-overview.md#2-logic-tier)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Test

### NFR8: OIDC-federated CI/CD authentication

- **Category:** Security
- **Description:** The CI/CD pipeline shall authenticate to AWS using short-lived credentials obtained via IAM OIDC federation with GitHub Actions, rather than long-lived IAM access keys.
- **Rationale:** Eliminates the risk of leaked long-lived credentials and follows AWS security best practices.
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Inspection

### NFR9: Billing alarm

- **Category:** Cost
- **Description:** A CloudWatch billing alarm shall be configured to alert if AWS costs exceed a defined threshold, to prevent unexpected charges during development.
- **Rationale:** Provides early warning of unexpected spend, protecting against runaway costs.
- **Related Architecture:** [Cross-Cutting Concerns](../architecture/architecture-overview.md#cross-cutting-concerns)
- **Acceptance Criteria:** Self-evident — no dedicated AC
- **Tracked by:** _TBD_
- **Verification Method:** Demonstration

## Non-Functional Requirements Register

| ID | Title | Category | Acceptance Criteria | Tracked by |
|----|-------|----------|----------------------|------------|
| NFR1 | High availability | Availability | Self-evident — no dedicated AC | _TBD_ |
| NFR2 | Free Tier cost constraint | Cost | AC-NFR2-1 | _TBD_ |
| NFR3 | No public write access to data | Security | Self-evident — no dedicated AC | _TBD_ |
| NFR4 | No credentials in source control | Security | Self-evident — no dedicated AC | _TBD_ |
| NFR5 | Infrastructure as Code | Maintainability | Self-evident — no dedicated AC | _TBD_ |
| NFR6 | Gated CI/CD auto-deploy | Maintainability | Self-evident — no dedicated AC | _TBD_ |
| NFR7 | Automated backend testing | Maintainability | Self-evident — no dedicated AC | _TBD_ |
| NFR8 | OIDC-federated CI/CD authentication | Security | Self-evident — no dedicated AC | _TBD_ |
| NFR9 | Billing alarm | Cost | Self-evident — no dedicated AC | _TBD_ |

---
_Sourced from the non-functional requirements defined in the public
[`cloud-resume-challenge`](https://github.com/waelLotfy/cloud-resume-challenge/blob/main/docs/01-Requirements/non-functional-requirements.md)
repository. Acceptance criteria and issue tracking links are to be filled
in as they are authored._
