"""

This function is intended to back an API Gateway route in the logic tier
(infrastructure/modules/logic) and update a DynamoDB table in the
data tier (infrastructure/modules/data).
Tracked by: TBD (see docs/traceability/README.md)
"""

#from __future__ import annotations

#from typing import Any

# ============================================================
# Lambda: IncrementVisitorCount (write-only)
# Triggered by: POST /visitorCount/increment (via API Gateway)
# Permissions: this function's IAM role allows ONLY dynamodb:UpdateItem
# ============================================================
import json
import os
import boto3

# boto3.resource("dynamodb") gives a higher-level, more Pythonic
# interface than boto3.client("dynamodb") - we work with a Table
# object instead of raw low-level API calls.
dynamodb = boto3.resource("dynamodb")

# The table name is NOT hardcoded. It comes from an environment
# variable set on the Lambda function itself (in Terraform), so
# the same code works unchanged across environments (prod/dev/etc).
TABLE_NAME = os.environ["TABLE_NAME"]
table = dynamodb.Table(TABLE_NAME)

# CORS headers, reused in every response (success or error).
# Access-Control-Allow-Origin: "*" allows any origin to call this API.
# You could restrict this to your exact CloudFront domain later for
# tighter security, but "*" is fine for a public read-only endpoint.
# Cache-Control: no-store tells any browser or intermediary cache
# (including CloudFront, if ever placed in front of this route) to
# NEVER cache this response - every increment must reach the real
# Lambda, never a stale cached copy. This is the "Latency Whisperer"
# mod's POST-caching safeguard, applied here instead of in CloudFront.
CORS_HEADERS = {
    "Access-Control-Allow-Origin": "*",
    "Content-Type": "application/json",
    "Cache-Control": "no-store",
}

def lambda_handler(event, context):
    try:
        # UpdateItem with an ADD expression increments the value
        # ATOMICALLY inside DynamoDB itself - safe even if many
        # visitors hit this at the exact same moment.
        #
        # ":incr" is a placeholder (an "expression attribute value")
        # standing in for the literal number 1, which DynamoDB
        # requires instead of writing raw numbers directly in the
        # expression string.
        #
        # ReturnValues="UPDATED_NEW" makes DynamoDB hand back the
        # value AFTER the increment, so we don't need a second
        # read to report the new count.
        response = table.update_item(
            Key={"id": "visitor_count"},
            UpdateExpression="ADD #count :incr",
            ExpressionAttributeNames={"#count": "count"},
            ExpressionAttributeValues={":incr": 1},
            ReturnValues="UPDATED_NEW",
        )

        new_count = int(response["Attributes"]["count"]) # Get the new visitor count after increment

        return {
            "statusCode": 200,
            "headers": CORS_HEADERS,
            "body": json.dumps({"visitorCount": new_count}),
        }

    except Exception as e:
        print(f"Error incrementing visitor count: {e}")
        return {
            "statusCode": 500,
            "headers": CORS_HEADERS,
            "body": json.dumps({"error": "Could not update visitor count."}),
        }