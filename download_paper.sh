#!/usr/bin/env sh

# https://docs.papermc.io/misc/downloads-service/

PROJECT="paper"
MINECRAFT_VERSION="1.21.11"
USER_AGENT="uw-archery-minecraft/1.0.0 (sc3lu@uwaterloo.com)"

BUILDS_RESPONSE=$(curl -s -H "User-Agent: $USER_AGENT" https://fill.papermc.io/v3/projects/${PROJECT}/versions/${MINECRAFT_VERSION}/builds)

# Check if the API returned an error
if echo "$BUILDS_RESPONSE" | jq -e '.ok == false' > /dev/null 2>&1; then
  ERROR_MSG=$(echo "$BUILDS_RESPONSE" | jq -r '.message // "Unknown error"')
  echo "Error: $ERROR_MSG"
  exit 1
fi

# Try to get a stable build URL for the requested version
PAPERMC_URL=$(echo "$BUILDS_RESPONSE" | jq -r 'first(.[] | select(.channel == "STABLE") | .downloads."server:default".url) // "null"')

echo $PAPERMC_URL
