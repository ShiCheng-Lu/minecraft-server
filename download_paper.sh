#!/usr/bin/env sh

# https://docs.papermc.io/misc/downloads-service/

PROJECT="paper"
MINECRAFT_VERSION="1.21.11"
USER_AGENT="uw-archery-minecraft/1.0.0 (sc3lu@uwaterloo.com)"

PAPERMC_URL=$(curl -s -H "User-Agent: $USER_AGENT" https://fill.papermc.io/v3/projects/${PROJECT}/versions/${MINECRAFT_VERSION}/builds) \
    | jq -r 'first(.[] | select(.channel == "STABLE") | .downloads."server:default".url) // "null"')

echo $PAPERMC_URL
