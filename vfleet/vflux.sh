#!/bin/bash

if [ "$1" == "" ]; then
    echo "usage: vflux.sh clusterName"
    exit 1
fi

KIC_V_CLUSTER=$1

if ! vcluster list | grep central-tx-atx-2301; then
    echo "vCluster $1 not found"
    exit 1
fi

vcluster connect $KIC_V_CLUSTER --silent &
sleep 5

kubectl create serviceaccount admin-user
kubectl create clusterrolebinding admin-user-binding --clusterrole cluster-admin --serviceaccount default:admin-user

kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: admin-user
  annotations:
    kubernetes.io/service-account.name: admin-user
type: kubernetes.io/service-account-token
EOF

kubectl apply -f "$KIC_BASE/clusters/$KIC_V_CLUSTER/flux-system/namespace.yaml"
flux create secret git flux-system -n flux-system --url "$KIC_REPO_FULL" -u gitops -p "$KIC_PAT"
flux create secret git gitops -n flux-system --url "$KIC_REPO_FULL" -u gitops -p "$KIC_PAT"

kubectl apply -f "$KIC_BASE/clusters/$KIC_V_CLUSTER/flux-system/components.yaml"
sleep 3
kubectl apply -f "$KIC_BASE/clusters/$KIC_V_CLUSTER/flux-system/source.yaml"
sleep 2
kubectl apply -R -f "$KIC_BASE/clusters/$KIC_V_CLUSTER/flux-system"
sleep 5

# force flux to sync
kic sync

# display results
kic pods
vcluster disconnect
