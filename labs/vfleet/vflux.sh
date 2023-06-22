#!/bin/bash

if [ "$1" == "" ]; then
    echo "usage: vflux.sh clusterName"
    exit 1
fi

# set the kube config
export KUBECONFIG="$HOME/.kube/$1.yaml"

kubectl create serviceaccount admin-user
kubectl create clusterrolebinding admin-user-binding --clusterrole cluster-admin --serviceaccount default:admin-user

kubectl create -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: admin-user
  annotations:
    kubernetes.io/service-account.name: admin-user
type: kubernetes.io/service-account-token
EOF

kubectl create -f "$KIC_BASE/clusters/$1/flux-system/namespace.yaml"
flux create secret git flux-system -n flux-system --url "$KIC_REPO_FULL" -u gitops -p "$KIC_PAT"
flux create secret git gitops -n flux-system --url "$KIC_REPO_FULL" -u gitops -p "$KIC_PAT"

kubectl create -f "$KIC_BASE/clusters/$1/flux-system/components.yaml"
sleep 3
kubectl create -f "$KIC_BASE/clusters/$1/flux-system/source.yaml"
sleep 2
kubectl create -R -f "$KIC_BASE/clusters/$1/flux-system"
sleep 5

# force flux to sync
kic sync

# display results
kic pods
