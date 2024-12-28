#!/bin/bash

# Get latest or specified tag version
if [ "$BOT_VERSION" == "latest" ]; then
  RELEASE_JSON=$(curl --silent "https://api.github.com/repos/${BOT_GITHUB}/releases/latest")
else
  RELEASE_JSON=$(curl --silent "https://api.github.com/repos/${BOT_GITHUB}/releases/tags/${BOT_VERSION}")
fi

# Check if the release JSON was fetched successfully
if [ -z "$RELEASE_JSON" ] || echo "$RELEASE_JSON" | grep -q '"message": "Not Found"'; then
  echo "Error: Could not find release for version '$BOT_VERSION'."
  echo "Possible release tags for ${BOT_GITHUB}:"
  curl --silent "https://api.github.com/repos/${BOT_GITHUB}/releases" | grep -Po '"tag_name":\s*"\K[^"]*' | head -n 10
  exit 1
fi

VERSION_TAG=$(echo "$RELEASE_JSON" | grep -Po '"tag_name":\s*"\K[^"]*')
ASSET_NAME=$(echo "$RELEASE_JSON" | grep -Po '"name":\s*"\KJMusicBot[^"]*\.jar')
DOWNLOAD_URL=$(echo "$RELEASE_JSON" | grep -Po '"browser_download_url":\s*"\Khttps://[^"]*JMusicBot[^"]*\.jar')

if [ -z "$ASSET_NAME" ] || [ -z "$DOWNLOAD_URL" ]; then
  echo "Error: No matching asset found in release $VERSION_TAG."
  exit 1
fi

echo -e "Downloading JMusicBot $VERSION_TAG"
if [ ! -f "$ASSET_NAME" ]; then
  if ! wget "$DOWNLOAD_URL" -O "$ASSET_NAME"; then
    echo "Error: Failed to download $ASSET_NAME."
    exit 1
  fi
fi

echo -e "Starting JMusicBot $VERSION_TAG"
java -Dnogui=true -Dconfig=/config/config.txt -jar "$ASSET_NAME"