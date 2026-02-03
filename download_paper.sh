
PROJECT="paper"
USER_AGENT="uw-archery-minecraft/1.0.0 (sc3lu@uwaterloo.com)"

LATEST_VERSION=$(curl -s -H "User-Agent: $USER_AGENT" https://fill.papermc.io/v3/projects/${PROJECT} | \
    jq -r '.versions | to_entries[0] | .value[0]')

echo "Latest version is $LATEST_VERSION"
