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

cd "$(dirname "$0")" || exit 1

set -e

# delete and create a new cluster
kic cluster create

# create the namespace
kubectl apply -f ns.yaml

# create secrets
kubectl create secret generic mssql -n res-edge \
    --from-literal=MSSQL_SA_PASSWORD="$MSSQL_SA_PASSWORD"

kubectl create secret generic api -n res-edge \
    --from-literal=SQL_CONN_STRING="Server=mssql;Database=ist;UID=sa;Password=Res-Edge-24;TrustServerCertificate=True;" \
    --from-literal=GIT_OPS_PAT="$PAT"

# note - this is to support an easy inner-loop
#        production should be integrated with AD, OpenId, or other SSO provider
kubectl create secret generic ui -n res-edge \
    --from-literal=DATA_SERVICE_URL="http://api:8080" \
    --from-literal=USER_PWD="Res-Edge-User" \
    --from-literal=ADMIN_PWD="Res-Edge-Admin"

# deploy SQL Server with sample data
kubectl apply -k mssql

# deploy cert-manager
#kubectl apply -k cert-manager

# echo
# echo 'waiting for cert-manager to start'
# sleep 10
# kubectl wait pod --all --for condition=ready -n cert-manager --timeout 60s

# deploy NGINX ingress controller
#kubectl apply -k nginx

# deploy monitoring and logging
kubectl apply -k monitoring

echo
echo 'waiting for mssql pod to start'
sleep 15
kubectl wait pod --all --for condition=ready -n res-edge --timeout 60s

echo
echo 'waiting for database recovery'
sleep 30

# echo
# echo 'waiting for NGINX to start'
# kubectl wait pod -l app.kubernetes.io/component=controller --for condition=ready -n ingress-nginx --timeout 60s

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
kubectl wait pod --all --for condition=ready -n monitoring --timeout 30s
kubectl wait pod --all --for condition=ready -n res-edge --timeout 60s
sleep 10

echo
echo "Checking Services"

ds check grafana
ds check prometheus
ds check res-edge
ds check ui
ds check webv
ds check sql
