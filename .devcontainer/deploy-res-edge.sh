#!/bin/bash

# Warning: this is a destructive command

# This script will create a new cluster and deploy Res-Edge Data Service
# Any prior data service changes will be overwritten and are not recoverable
# Use the --force flag to make the database changes

# a little protection
if [ "$1" != "--force" ]; then
    echo ""
    echo "This is a destructive command that deletes your current cluster"
    echo "and creates a new cluster with Res-Edge Data Service deployed"
    echo ""
    echo "Usage: .devcontainer/deploy-res-edge.sh --force"
    echo ""
    exit 1
fi

cd "$(dirname "$0")/../deploy" || exit 1

set -e

# delete and create a new cluster
kic cluster create

# create the namespace
kubectl apply -f ns.yaml

# deploy SQL Server with sample data
kubectl apply -k mssql

# deploy monitoring and logging
kubectl apply -k monitoring

echo
echo 'waiting for mssql pod to start'
kubectl wait pod --all --for condition=ready -n res-edge --timeout 60s

echo
echo 'waiting for database recovery'
sleep 30

# load the data
ds reload --force

# deploy the Res-Edge Data Service
kubectl apply -k api

echo
echo 'waiting for api pod to start'

# wait for pod to start
kubectl wait pod --all --for condition=ready -n res-edge --timeout 60s

# deploy ui
kubectl apply -k ui

# deploy webv
kubectl apply -k webv

echo
echo "Waiting for pods to start"
kubectl wait pod --all --for condition=ready -n logging --timeout 60s
kubectl wait pod --all --for condition=ready -n monitoring --timeout 30s
kubectl wait pod --all --for condition=ready -n res-edge --timeout 60s
