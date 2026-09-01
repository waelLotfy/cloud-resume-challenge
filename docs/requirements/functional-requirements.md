# Functional Requirements

> **Status:** Placeholder. No functional requirements have been authored yet.
> This document defines the format to be used once real requirements are
> written. Do not add content here until requirements have been reviewed
> and agreed upon.

## Purpose

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
- **Acceptance Criteria:** <link(s) to acceptance-criteria.md>
- **Tracked by:** #<issue-number>
- **Verification Method:** <Test | Analysis | Inspection | Demonstration>
```

## Functional Requirements Register

| ID | Title | Tier/Component | Acceptance Criteria | Tracked by |
|----|-------|----------------|----------------------|------------|
| _(none yet)_ | | | | |

---
_No functional requirements (FR1–FR25) have been written yet. This table
will be populated as requirements are authored and reviewed._
