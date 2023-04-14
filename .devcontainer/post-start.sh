#!/bin/bash

# this runs each time the container starts

echo "post-start start"
echo "$(date +'%Y-%m-%d %H:%M:%S')    post-start start" >> "$HOME/status"

echo "Pulling docker images"
docker pull mcr.microsoft.com/dotnet/sdk:6.0
docker pull mcr.microsoft.com/dotnet/aspnet:6.0-alpine

if [ -z "$KIC_RESEDGE_WEBV" ]
then
    KIC_RESEDGE_WEBV=ghcr.io/cse-labs/res-edge-sql:beta
fi

if [ -z "$KIC_GITOPS_AUTOMATION" ]
then
    KIC_GITOPS_AUTOMATION=ghcr.io/cse-labs/res-edge-automation:0.8.5
fi

docker pull "${KIC_RESEDGE_WEBV}"
docker pull "${KIC_GITOPS_AUTOMATION}"

echo "post-start complete"
echo "$(date +'%Y-%m-%d %H:%M:%S')    post-start complete" >> "$HOME/status"
