# GitOps Lab (ArgoCD)

- In this lab, we will use GitOps (ArgoCD) to deploy the Namespaces and Applications assigned to a Cluster
  - We refer to this Cluster as a "member cluster"
    - Member clusters can be listed with the `ds clusters list` command
    - We will use `central-la-nola-2301` as our member cluster name
      - You can use any cluster in the
- The default deployment will include
  - ArgoCD
  - heartbeat
  - redis

## Work in Progress

- Create a branch from the argo branch before running the lab

  ```bash

  git pull
  git checkout argo
  git pull
  git checkout -b $MY_BRANCH
  git push -u origin $MY_BRANCH

  ```

- todo - add CLI to branch / setup
- Rebuild your Codespace
  - Click on `Codespaces` in the lower left corner of this window
  - Rebuild Codespace

- Install Res-Edge Data Service
  - This satisfies the prerequisites
  - `.devcontainer/deploy-res-edge.sh --force`

- Verify `kic` and `ds` versions are 0.12.x

  ```bash

  kic -v
  ds -v

  ```

## Prerequisites

- Deploy the Res-Edge [data service](./deploy-res-edge.md)

## Setup a clean environment

```bash

# start in the repo base directory
cd "$KIC_BASE"

# Warning: this will delete any existing data changes and they are not recoverable
ds reload --force

# update GitOpsRepo and Branch
# todo - make this part of reload
ds update-gitops

# run ci-cd locally
ds cicd

# deploy the clusters directory changes
ds deploy

```

## ArgoCD Setup Files

- todo - update this
- The Flux setup yaml is located in `clusters/central-la-nola-2301/flux-system`
  - A `Flux source` is a git repo / branch combination
  - A `Flux kustomization` is a directory within the source (flux-system in our case)
    - flux-kustomization watches the flux-system and flux-system/listeners directories
    - You want to have multiple kustomizations in your deployment
      - When a kustomization fails, the entire process is aborted
        - This lets "your app" break "my app" if we use the same kustomization
      - We create a kustomization per Namespace as part of Res-Edge-Automation (`ds cicd`)

## Setup Member Cluster

- Normally, the "member cluster" would be a separate cluster from the cluster running the data service
  - For simplicty, we are going to run our current cluster in both modes
  - Optionally, you can create a new Codespace that will be a "member cluster"

## Getting started

- Verify the data service is running

  ```bash

  kic check resedge

  ```

## Deploy GitOps (ArgoCD)

- This deploys GitOps (ArgoCD) to your cluster

```bash

# change central-la-nola-2301 to deploy additional member clusters
cd "$KIC_BASE"

# deploy argo
kubectl apply -k clusters/central-la-nola-2301/argocd

```

## Verify ArgoCD Deployment

- Argo should create 2 new Namespaces
  - heartbeat
  - redis

```bash

# check for ArgoCD "Applications"
kic check argo

# force argo to sync
kic argo sync

# make sure the pods are running
kic pods

# check heartbeat
kic check heartbeat

# check redis
kic check redis

```

## Deploy IMDb

```bash

# add imdb app to NOLA stores (clusters)
# will return 204 No Content
ds set-expression --id 3 --expression /g/stores/central/la/nola

# run ci-cd locally
ds cicd

# deploy the clusters directory changes
ds deploy

### todo - add steps to check for argo updates and pods

# check imdb
kic check imdb

```

## Additional Member Clusters

- You can create additional Codespaces as member clusters
- Use a different Cluster name / directory for each cluster

> On the [GitHub Codespaces page](https://github.com/codespaces), you can change the name of the Codespace by clicking the `...`
