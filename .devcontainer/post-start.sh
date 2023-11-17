#!/bin/bash

# this runs each time the container starts

echo "post-start start"
echo "$(date +'%Y-%m-%d %H:%M:%S')    post-start start" >> "$HOME/status"

echo "Pulling docker images"
docker pull mcr.microsoft.com/dotnet/sdk:7.0
docker pull mcr.microsoft.com/dotnet/aspnet:7.0-alpine
docker pull ghcr.io/cse-labs/res-edge-webv:0.15
docker pull ghcr.io/cse-labs/res-edge-automation:0.15

echo "post-start complete"
echo "$(date +'%Y-%m-%d %H:%M:%S')    post-start complete" >> "$HOME/status"
