"""
This function is intended to back an API Gateway route in the logic tier
(infrastructure/modules/logic) and read a DynamoDB table in the
data tier (infrastructure/modules/data).
Tracked by: TBD (see docs/traceability/README.md)
"""

#from __future__ import annotations

#from typing import Any

# ============================================================
# Lambda: GetVisitorCount (read-only)
# Triggered by: GET /visitorCount (via API Gateway)
# Permissions: this function's IAM role allows ONLY dynamodb:GetItem
# ============================================================
import json
import os
import boto3

# boto3.resource("dynamodb") gives a higher-level, more Pythonic
# interface than boto3.client("dynamodb") - we work with a Table
# object instead of raw low-level API calls.
dynamoDB = boto3.resource("dynamodb") # Create a DynamoDB resource object

# The table name is NOT hardcoded. It comes from an environment
# variable set on the Lambda function itself (in Terraform), so
# the same code works unchanged across environments (prod/dev/etc).
TABLE_NAME = os.environ["TABLE_NAME"] # Get the table name from the environment variable
table = dynamoDB.Table(TABLE_NAME) # Get the DynamoDB table object

# CORS headers, reused in every response (success or error).
# Access-Control-Allow-Origin: "*" allows any origin to call this API.
# It could be restricted to your exact CloudFront domain later for
# tighter security, but "*" is fine for a public read-only endpoint.
# Cache-Control: no-store is included even on this READ endpoint,
# not because a bug exists today, but because the underlying value
# changes on every write - any future caching layer (browser,
# proxy, CDN) added later must never serve a stale count here either.
CORS_HEADERS = {
    "Access-Control-Allow-Origin": "*", # Allow any origin to call this API
    "Content-Type": "application/json", # Set the content type to JSON
    "Cache-Control": "no-store", # Do not cache the response
}

def lambda_handler(event, context):
    try:
        # GetItem fetches exactly one item by its key.
        # "id" here must match the hash_key name defined in Terraform.
        response = table.get_item(Key={"id": "visitor_count"}) # Get the item with id "visitor_count"

        # If the item doesn't exist yet (e.g. very first request ever,
        # before any increment has happened), default to 0 instead of
        # crashing on a missing "Item" key.
        visitor_count = response.get("Item", {}).get("count", 0) # Get the visitor count, default to 0 if not found

        # DynamoDB returns numbers as Decimal, not int.
        # json.dumps() cannot serialize Decimal directly - convert first.
        visitor_count = int(visitor_count) # Convert the visitor count to an integer

        # Return a successful response with the visitor count
        return {
            "statusCode": 200, # HTTP status code 200 OK
            "headers": CORS_HEADERS, # Include CORS headers
            "body": json.dumps({"visitorCount": visitor_count}), # Return the visitor count as JSON
        }
    except Exception as e:
        # Anything unexpected (permissions issue, malformed data, etc.)
        # gets logged automatically to CloudWatch (print() output shows
        # up there), and we return a generic 500 rather than leaking
        # internal error details to the browser.
        print(f"Error getting visitor count: {e}")
        return {
            "statusCode": 500,
            "headers": CORS_HEADERS,
            "body": json.dumps({"error": "Could not retrieve visitor count."}),
        }