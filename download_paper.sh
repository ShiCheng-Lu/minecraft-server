#!/usr/bin/env sh

# https://docs.papermc.io/misc/downloads-service/

PROJECT="paper"
MINECRAFT_VERSION="1.21.11"
USER_AGENT="uw-archery-minecraft/1.0.0 (sc3lu@uwaterloo.com)"

# First check if the requested version has a stable build
BUILDS_RESPONSE=$(curl -s -H "User-Agent: $USER_AGENT" https://fill.papermc.io/v3/projects/${PROJECT}/versions/${MINECRAFT_VERSION}/builds)

# Check if the API returned an error
if echo "$BUILDS_RESPONSE" | jq -e '.ok == false' > /dev/null 2>&1; then
  ERROR_MSG=$(echo "$BUILDS_RESPONSE" | jq -Rr '.message // "Unknown error"')
  echo "Error: $ERROR_MSG"
  exit 1
fi

# Try to get a stable build URL for the requested version
PAPERMC_URL=$(echo "$BUILDS_RESPONSE" | jq -Rr 'first(.[] | select(.channel == "STABLE") | .downloads."server:default".url) // "null"')
FOUND_VERSION="$MINECRAFT_VERSION"

# If no stable build for requested version, find the latest version with a stable build
if [ "$PAPERMC_URL" = "null" ]; then
  echo "No stable build for version $MINECRAFT_VERSION, searching for latest version with stable build..."

  # Get all versions for the project (using the same endpoint structure as the "Getting the latest version" example)
  # The versions are organized by version group, so we need to extract all versions from all groups
  # Then sort them properly as semantic versions (newest first)
  VERSIONS=$(curl -s -H "User-Agent: $USER_AGENT" https://fill.papermc.io/v3/projects/${PROJECT} | \
    jq -Rr '.versions | to_entries[] | .value[]' | \
    sort -V -r)

  # Iterate through versions to find one with a stable build
  for VERSION in $VERSIONS; do
    VERSION_BUILDS=$(curl -s -H "User-Agent: $USER_AGENT" https://fill.papermc.io/v3/projects/${PROJECT}/versions/${VERSION}/builds)

    # Check if this version has a stable build
    STABLE_URL=$(echo "$VERSION_BUILDS" | jq -Rr 'first(.[] | select(.channel == "STABLE") | .downloads."server:default".url) // "null"')

    if [ "$STABLE_URL" != "null" ]; then
      PAPERMC_URL="$STABLE_URL"
      FOUND_VERSION="$VERSION"
      echo "Found stable build for version $VERSION"
      break
    fi
  done
fi

if [ "$PAPERMC_URL" != "null" ]; then
  # Download the latest Paper version
  curl -o server.jar $PAPERMC_URL
  echo "Download completed (version: $FOUND_VERSION)"
else
  echo "No stable builds available for any version :("
  exit 1
fi