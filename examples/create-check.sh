#!/usr/bin/env bash
# Create a check over REST, then long-poll for results.
set -euo pipefail
: "${PROOFHAND_KEY:?export PROOFHAND_KEY=ph_live_…}"

check=$(curl -sS -X POST https://proofhand.dev/api/v1/checks \
  -H "Authorization: Bearer $PROOFHAND_KEY" \
  -H "Idempotency-Key: signup-check-$(date +%Y%m%d)" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Signup works on phones",
    "target_url": "https://staging.yourapp.com/signup",
    "steps": [{"instruction": "Create an account with a new email", "expected": "The welcome screen appears"}],
    "devices": ["ios-safari", "android-chrome"]
  }')
id=$(echo "$check" | python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])')
echo "created $id"

curl -sS "https://proofhand.dev/api/v1/checks/$id?wait=60" -H "Authorization: Bearer $PROOFHAND_KEY"
