# Contributing

## V-Model SDLC

This project follows a V-Model SDLC: Requirements → Architecture →
Implementation → Testing → Deployment → Documentation. See
[`docs/README.md`](./docs/README.md) for how each stage maps to a
directory in this repository.

## Commit Message Convention

Commits follow [Conventional Commits](https://www.conventionalcommits.org/),
extended with a requirement-traceability reference so that every change
can be traced back to a GitHub Issue tracking a functional (`FRn`) or
non-functional (`NFRn`) requirement (see
[`docs/traceability/README.md`](./docs/traceability/README.md)).

### Format

```
<type>(<scope>): <short description> (#<issue-number>)
```

- **type:** `feat`, `fix`, `docs`, `test`, `refactor`, `chore`, `ci`
- **scope:** the affected area, e.g. `lambda`, `frontend`, `infra`,
  `presentation`, `logic`, `data`, `docs`
- **issue-number:** the GitHub Issue tracking the requirement this commit
  implements

### Example

```
feat(lambda): implement visitor counter increment (#12)
```

Pull request descriptions should additionally use a closing keyword
(e.g. `Closes #12`) so GitHub automatically links and closes the
corresponding requirement issue on merge. See
[`.github/pull_request_template.md`](./.github/pull_request_template.md).

## Requirement Issues

Requirement issues are filed using the
[Requirement issue template](./.github/ISSUE_TEMPLATE/requirement.md)
once real requirement content exists in
[`docs/requirements/`](./docs/requirements).

## Terraform Changes

- Each tier module (`infrastructure/modules/presentation`,
  `infrastructure/modules/logic`, `infrastructure/modules/data`) must
  remain independent — do not add direct references between modules.
  Cross-tier wiring belongs in
  `infrastructure/environments/prod/main.tf`.
- No VPC, subnet, or networking resources should be added — this project
  deliberately has no VPC.

## Tests

- Add/update tests under [`tests/`](./tests) (`unit/`, `integration/`,
  `acceptance/`) alongside any implementation change, and reference the
  acceptance criterion ID(s) the test verifies.
