#!/usr/bin/env sh

# https://docs.papermc.io/misc/downloads-service/

PROJECT="paper"
MINECRAFT_VERSION="1.21.11"
USER_AGENT="uw-archery-minecraft/1.0.0 (sc3lu@uwaterloo.com)"

LATEST_BUILD=$(curl -s -H "User-Agent: $USER_AGENT" https://fill.papermc.io/v3/projects/${PROJECT}/versions/${MINECRAFT_VERSION}/builds | \
  jq -r 'map(select(.channel == "STABLE")) | .[0] | .id')

if [ "$LATEST_BUILD" != "null" ]; then
  echo "Latest stable build is $LATEST_BUILD"
else
  echo "No stable build for version $MINECRAFT_VERSION found :("
fi