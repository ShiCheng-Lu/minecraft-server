#!/usr/bin/env sh

# https://docs.papermc.io/misc/downloads-service/

PROJECT="paper"
USER_AGENT="uw-archery-minecraft/1.0.0 (sc3lu@uwaterloo.com)"

LATEST_VERSION=$(curl -s -H "User-Agent: $USER_AGENT" https://fill.papermc.io/v3/projects/${PROJECT} | \
    jq -r '.versions | to_entries[0] | .value[0]')

echo "Latest version is $LATEST_VERSION"

PAPERMC_URL=$(curl -s -H "User-Agent: $USER_AGENT" https://fill.papermc.io/v3/projects/${PROJECT}/versions/${LATEST_VERSION}/builds \
    | jq -r 'first(.[] | select(.channel == "STABLE") | .downloads."server:default".url) // "null"')

echo "Latest build url is $PAPERMC_URL"

curl -o server.jar $PAPERMC_URL
