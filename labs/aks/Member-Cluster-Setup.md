# Deploy Member Cluster to AKS

> Make create the cluster from first `README.md`

- Start in the `labs/aks/deploy` directory

```bash

cd "$KIC_BASE/labs/aks/deploy"

```

- Check environment variables

```bash

env | grep ^REZ_

```

## Arc Enable GitOps

```bash

# Add flux extension
az k8s-configuration flux create \
  --cluster-type connectedClusters \
  --interval 1m \
  --kind git \
  --name gitops \
  --namespace flux-system \
  --scope cluster \
  --timeout 3m \
  --https-user gitops \
  --cluster-name "$REZ_AKS_NAME" \
  --resource-group "$REZ_ARC_RG" \
  --url "$REZ_REPO" \
  --branch "$REZ_BRANCH" \
  --https-key "$PAT" \
  --kustomization \
      name=flux-system \
      path=./clusters/"$REZ_AKS_NAME"/flux-system/listeners \
      timeout=3m \
      sync_interval=1m \
      retry_interval=1m \
      prune=true \
      force=true

# force flux update
ds sync

# you will need this to connect to Arc
export REZ_ARC_TOKEN=$(kubectl get secret arc-secret -o jsonpath='{$.data.token}' | base64 -d | sed 's/$/\n/g')
echo $REZ_ARC_TOKEN

```

## Wait for GitOps

- Make sure that GitOps runs
  - `ds sync` will cause GitOps to synch without waiting for the delay
- Make sure that ingress-nginx and cert-manager are deployed

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

# set cluster domain
az network dns record-set a add-record \
-g "$REZ_DNS_RG" \
-z "$REZ_DNS_ZONE" \
-n "$REZ_AKS_NAME" \
-a "$REZ_IP" \
--ttl 10 \
-o table

# set dogs-cats domain
az network dns record-set a add-record \
-g "$REZ_DNS_RG" \
-z "$REZ_DNS_ZONE" \
-n "dogs-cats.$REZ_AKS_NAME" \
-a "$REZ_IP" \
--ttl 10 \
-o table

# set tabs-spaces domain
az network dns record-set a add-record \
-g "$REZ_DNS_RG" \
-z "$REZ_DNS_ZONE" \
-n "tabs-spaces.$REZ_AKS_NAME" \
-a "$REZ_IP" \
--ttl 10 \
-o table

# Check DNS
http http://$REZ_FQDN/heartbeat/16

```

## Cleanup

```bash

# Delete the Kubernetes context
kubectl config delete-context $LAB_AKS_NAME

# Delete the Resource Group
# todo - delete cluster and arc
# az group delete -y --no-wait -g $LAB_AKS_RG
# az group list -o table

```

- Delete the A record(s)

```bash

az network dns record-set a remove-record \
-g "$LAB_DNS_RG" \
-z "$LAB_DNS_ZONE" \
-n "$LAB_DNS_HOST" \
-a "$LAB_IP" \
-o table

az network dns record-set a remove-record \
-g "$LAB_DNS_RG" \
-z "$LAB_DNS_ZONE" \
-n "dogs-cats.$LAB_DNS_HOST" \
-a "$LAB_IP" \
-o table

az network dns record-set a remove-record \
-g "$LAB_DNS_RG" \
-z "$LAB_DNS_ZONE" \
-n "tabs-spaces.$LAB_DNS_HOST" \
-a "$LAB_IP" \
-o table

```
