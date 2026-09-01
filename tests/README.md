# Tests

Test suites for the Cloud Resume Challenge project, mapped to the
Testing stage of the V-Model SDLC and traced back to
[`docs/requirements/acceptance-criteria.md`](../docs/requirements/acceptance-criteria.md).

## Structure

| Directory | Scope | Corresponds to |
|-----------|-------|-----------------|
| [`unit/`](./unit) | Individual functions/modules in isolation (e.g. `backend/` Lambda handlers) | Implementation stage |
| [`integration/`](./integration) | Multiple deployed components together (e.g. API Gateway → Lambda → DynamoDB) | Architecture stage |
| [`acceptance/`](./acceptance) | End-to-end behavior against documented acceptance criteria | Requirements stage |

## Running Tests

```bash
pip install -r backend/requirements.txt
pip install pytest
pytest tests/
```

## Status

All test files are placeholders (`@pytest.mark.skip`) pending real
requirement content in `docs/requirements/`. Each test, once written,
must reference the acceptance criterion ID it verifies.
