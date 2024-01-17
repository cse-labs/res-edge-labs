# Deploy Res-Edge to AKS

## Getting Started

- Start in the `labs/aks/deploy` directory

```bash

cd "$KIC_BASE/labs/aks/deploy"

```

## Deploy NGINX and cert-manager

```bash

kubectl apply -k nginx
kubectl apply -k cert-manager

```

## Setup Let's Encrypt (optional)

- Be careful not to exceed the Let's Encrypt rate limits while testing
  - You need to change all of the ingress rules in `GitOps Repo Applications`

```bash

kubectl apply -k lets-encrypt

```

## Deploy Res-Edge

- Modify the GitOps repo args in `api/deployment.yaml` to use your GitOps repo and branch

```bash

code api/deployment.yaml

```

- Create Secrets
  - Make sure the `PAT` environment variable is set and has permissions to the GitOps Repo

```bash

# create the namespace
kubectl apply -f mssql/ns.yaml

# create secrets
kubectl create secret generic mssql -n res-edge \
    --from-literal=MSSQL_SA_PASSWORD="$MSSQL_SA_PASSWORD"

kubectl create secret generic api -n res-edge \
    --from-literal=SQL_CONN_STRING="Server=mssql;Database=ist;UID=sa;Password=$MSSQL_SA_PASSWORD;TrustServerCertificate=True;" \
    --from-literal=GIT_OPS_PAT="$PAT"

# note - this is to support an easy inner-loop
#        production should be integrated with AD, OpenId, or other SSO provider
kubectl create secret generic ui -n res-edge \
    --from-literal=DATA_SERVICE_URL="http://api:8080" \
    --from-literal=USER_PWD="Res-Edge-User" \
    --from-literal=ADMIN_PWD="Res-Edge-Admin"

# Deploy SQL Server
kubectl apply -k mssql

echo
echo 'waiting for sql to start'
kubectl wait pod --all --for condition=ready -n res-edge --timeout 60s

# Deploy API
kubectl apply -k api

echo
echo 'waiting for pod to start'
kubectl wait pod --all --for condition=ready -n res-edge --timeout 60s

# Deploy UI
kubectl apply -k ui

echo
echo 'waiting for pod to start'
kubectl wait pod --all --for condition=ready -n res-edge --timeout 60s

kubectl get pods -A

```

## Setup DNS

- Get the Load Balancer public IP

```bash

# get the public load balancer IP
export REZ_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# check the env vars
env | grep ^REZ_

```

- Create a DNS A Record in Azure DNS

```bash

# set naked domain (for UI)
az network dns record-set a add-record \
-g "$REZ_DNS_RG" \
-z "$REZ_DNS_ZONE" \
-n "@" \
-a "$REZ_IP" \
--ttl 10 \
-o table

# set api.domain
az network dns record-set a add-record \
-g "$REZ_DNS_RG" \
-z "$REZ_DNS_ZONE" \
-n "api" \
-a "$REZ_IP" \
--ttl 10 \
-o table

# Check DNS
http https://$REZ_DNS_ZONE/version
http https://api.$REZ_DNS_ZONE/version

  ```

## Cleanup

```bash

# Delete the Kubernetes context
kubectl config delete-context $REZ_AKS_NAME

# Delete the Resource Group
# todo - delete cluster
#az group delete -y --no-wait -g $REZ_AKS_RG
#az group list -o table

```

- Delete the A record(s)

```bash

az network dns record-set a remove-record \
-g "$REZ_DNS_RG" \
-z "$REZ_DNS_ZONE" \
-n "@" \
-a "$REZ_IP" \
-o table

az network dns record-set a remove-record \
-g "$REZ_DNS_RG" \
-z "$REZ_DNS_ZONE" \
-n "api" \
-a "$REZ_IP" \
-o table

```
