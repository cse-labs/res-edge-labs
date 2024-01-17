# Deploy Res-Edge to AKS

This lab is designed to help you securely expose your Kubernetes services over HTTPS and deploy multiple applications using `path-based` and `host-based` routing. This can be useful if you have multiple applications running on your cluster and want to ensure that each one is accessible via its own unique and HTTPS secured URL. This lab uses:

- [AKS Cluster](https://learn.microsoft.com/en-us/azure/aks/): Azure Kubernetes Service to deploy and manage cloud native applications in Azure
- [NGINX](https://nginx.org/): An ingress controller for Kubernetes that works by deploying the Envoy proxy as a reverse proxy and load balancer
- [cert-manager](https://cert-manager.io/docs/): A Certificate Controller to provision and manage TLS certifications from `Let's Encrypt` or any other issuer
- [Let's Encrypt (optional)](https://letsencrypt.org/about/): A Certificate Authority (CA) to get a certificate for your domain

## Prerequisites

- A public GitHub account
- An Azure subscription
- A domain name and DNS server
  - Instructions for using Azure DNS are included

## Getting Started

- Create / checkout a GitOps repo and branch

```bash

cd "$KIC_BASE"
git clone "$KIC_REPO_FULL" .gitops
cd .gitops

```

- Checkout existing branch (if exists)

```bash

  git checkout aks-$MY_BRANCH
  git pull
  cd ..

```

- Create a new branch

```bash
  git checkout aks
  git pull
  git checkout -b aks-$MY_BRANCH
  git push -u origin aks-$MY_BRANCH
  cd ..

  ```

- Login to Azure
  - Select the correct subscription if applicable

```bash

# use a device code or service principle from Codespaces
az login [--use-device-code]

```

- Add Azure Arc Dependencies
  - You only have to do this once per dev machine

```bash

az extension add --yes --upgrade --name connectedk8s
az extension add --yes --upgrade --name k8s-configuration
az extension add --yes --upgrade --name  k8s-extension
az provider register --wait --consent-to-permissions --namespace Microsoft.Kubernetes
az provider register --wait --consent-to-permissions --namespace Microsoft.KubernetesConfiguration
az provider register --wait --consent-to-permissions --namespace Microsoft.ExtendedLocation

```

- Set env variables
  - If you change the DNS Zone, make sure to update all ingress rules!

```bash

export REZ_AKS_RG=clusters
export REZ_ARC_RG=arc

export REZ_DNS_ZONE=res-edge.com
export REZ_DNS_RG=tld
export REZ_REPO="$KIC_REPO_FULL"
export REZ_BRANCH=aks-$MY_BRANCH
export REZ_LOCATION=eastus

# Res-Edge cluster
export REZ_AKS_NAME=res-edge

# beta clusters
export REZ_AKS_NAME=central-la-nola-2301
export REZ_AKS_NAME=east-ga-atl-2301
export REZ_AKS_NAME=west-ca-sd-2301

# pilot clusters
export REZ_AKS_NAME=central-tx-atx-2301
export REZ_AKS_NAME=east-nc-clt-2301
export REZ_AKS_NAME=west-wa-sea-2301

# select one of the clusters from above
export REZ_AKS_NAME=central-la-nola-2301

# Set Location and Resource Group names
export REZ_AKS_NODE_RG=nodes-${REZ_AKS_NAME}

# Set DNS Information
export REZ_FQDN=$REZ_AKS_NAME.$REZ_DNS_ZONE

# unset these variables
unset REZ_IP
unset REZ_ARC_TOKEN

# check variables
env | grep ^REZ_

```

## Create the cluster

```bash

# Create a Resource Group
az group create -n $REZ_AKS_RG -l $REZ_LOCATION
az group create -n $REZ_ARC_RG -l $REZ_LOCATION

# Create an AKS Cluster
# This command will create SSH key files in `$HOME/.ssh`
# Copy your `id_rsa` and `id_rsa.pub` to `$HOME/.ssh` if you want to use existing SSH keys

az aks create \
  -g $REZ_AKS_RG \
  -n $REZ_AKS_NAME \
  --node-resource-group $REZ_AKS_NODE_RG \
  --generate-ssh-keys \
  --enable-managed-identity \
  --node-count 1 \
  --node-vm-size standard_a4_v2

```

- Login to the AKS Cluster

```bash

az aks get-credentials -g $REZ_AKS_RG -n $REZ_AKS_NAME

# check the pods
kubectl get pods --all-namespaces

```

## Connect Cluster to Arc

```bash

# create Arc token
kubectl create serviceaccount arc -n default
kubectl create clusterrolebinding demo-user-binding --clusterrole cluster-admin --serviceaccount default:arc

kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: arc-secret
  annotations:
    kubernetes.io/service-account.name: arc
type: kubernetes.io/service-account-token
EOF

# Connect AKS to Arc
az connectedk8s connect --name $REZ_AKS_NAME --resource-group $REZ_ARC_RG

# you will need this to connect to Arc from the portal
export REZ_ARC_TOKEN=$(kubectl get secret arc-secret -o jsonpath='{$.data.token}' | base64 -d | sed 's/$/\n/g')
echo $REZ_ARC_TOKEN

```

## Deploy Res-Edge

- Res-Edge Setup - 'Res-Edge-Setup.md'

## Deploy `Member Cluster(s)`

- Member Cluster Setup - `Member-Cluster-Setup.md`
