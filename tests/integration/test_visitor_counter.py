"""
Smoke tests for the visitor counter API.

These call the REAL, deployed API Gateway endpoint - no mocking.
A passing run here proves the Lambda code, IAM permissions, and
DynamoDB wiring are correctly deployed and working together, not
just that the Python logic is correct in isolation.
"""

# The real, live API base URL - same value used in main.js.
API_BASE_URL = "https://gbxfq66ns3.execute-api.eu-central-1.amazonaws.com"

def test_get_visitor_count_returns_a_number(api_request_context):
    # Call the real GET endpoint.
    response = api_request_context.get(f"{API_BASE_URL}/visitorCount")

    # Confirm the HTTP call itself succeeded.
    assert response.ok, f"Expected 2xx, got {response.status}"

    # Parse the JSON body and confirm the field exists and is a number.
    data =response.json()
    assert isinstance(data["visitorCount"], int)

def test_increment_then_get_reflects_the_new_value(api_request_context):

    # Step 1: read the count BEFORE incrementing.
    before_response = api_request_context.get(f"{API_BASE_URL}/visitorCount")
    assert before_response.ok, f"Expected 2xx, got {before_response.status}"
    count_before = before_response.json()["visitorCount"]

    # Step 2: call the real POST endpoint to increment the count.
    increment_response = api_request_context.post(f"{API_BASE_URL}/visitorCount/increment")
    assert increment_response.ok, f"Expected 2xx, got {increment_response.status}"
    count_from_post = increment_response.json()["visitorCount"]

    # Confirm it increased by EXACTLY 1 - catches bugs like incrementing
    # by the wrong amount, or accidentally resetting instead of adding.
    assert count_from_post == count_before + 1, (
        f"Expected {count_before + 1}, got {count_from_post}"
    )

    # Step 3: THE IMPORTANT CHECK - call GET again, independently.
    # This proves DynamoDB itself was actually updated, not just that
    # the Lambda's own response claimed success while the database
    # silently stayed unchanged.
    after_response = api_request_context.get(f"{API_BASE_URL}/visitorCount")
    assert after_response.ok, f"Expected 2xx, got {after_response.status}"
    count_after = after_response.json()["visitorCount"]

    assert count_after == count_from_post
