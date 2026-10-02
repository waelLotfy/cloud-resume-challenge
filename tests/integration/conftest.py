"""
Shared pytest fixtures for the integration test suite.

pytest automatically discovers conftest.py and makes everything
defined here available to every test file in this folder - no
import statement needed in the test files themselves.
"""

import pytest

@pytest.fixture(scope="session")
def api_request_context(playwright):
    # `playwright` here is pytest-playwright's own built-in fixture -
    # it's the raw Playwright driver object, confirmed available in
    # your fixture list. We use it to manually create an API request
    # client, since this version of pytest-playwright has no
    # ready-made fixture for API-only testing.
    request_context = playwright.request.new_context()

    # `yield` (instead of `return`) lets us run cleanup code AFTER
    # the test finishes using this fixture - everything after yield
    # only runs once the test is done, success or failure.
    yield request_context

    # Release the underlying connection/resources cleanly.
    request_context.dispose()