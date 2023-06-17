# GitOps Lab (ArgoCD)

- In this lab, we will use GitOps (ArgoCD) to deploy the Namespaces and Applications assigned to a Cluster
  - We refer to this Cluster as a "member cluster"
    - Member clusters can be listed with the `ds clusters list` command
    - We will use `central-la-nola-2301` as our member cluster name
      - You can use any cluster in the data service
- The default deployment will include
  - ArgoCD
  - heartbeat
  - redis
  - heartbeat and redis are deployed by ArgoCD based on the data service settings

## Work in Progress

- Create a branch from the argo branch before running the lab

  ```bash

  git pull
  git checkout argo
  git pull
  git checkout -b $MY_BRANCH
  git push -u origin $MY_BRANCH

  ```

- Rebuild your Codespace
  - Click on `Codespaces` in the lower left corner of this window
  - Rebuild Codespace

- Verify `kic` and `ds` versions are 0.12.0

  ```bash

  kic -v
  ds -v

  ```

## Prerequisites

- Deploy the Res-Edge Data Service

  ```bash

  .devcontainer/deploy-res-edge.sh --force

  ```

- Verify the data service is running

  ```bash

  kic check resedge

  ```

## Update Data Service data

```bash

# start in the repo base directory
cd "$KIC_BASE"

# update GitOpsRepo and Branch
ds update-gitops

# run ci-cd locally
ds cicd

# deploy the clusters directory changes
ds deploy

```

## Setup Member Cluster

- Normally, the "member cluster" would be a separate cluster from the cluster running the data service
  - For simplicty, we are going to run our current cluster in both modes
  - Optionally, you can create a new Codespace that will be a "member cluster"

## Deploy GitOps (ArgoCD)

- This deploys GitOps (ArgoCD) to your cluster

```bash

# change central-la-nola-2301 to deploy additional member clusters
cd "$KIC_BASE"

# deploy argo
kubectl apply -k clusters/central-la-nola-2301/argocd

```

## Verify ArgoCD Deployment

- Argo should create 3 new Namespaces
  - argocd
  - heartbeat
  - redis

```bash

# check for ArgoCD "Applications"
kic check argo

# login to argo CLI
kic argo login

# force argo to sync
kic argo sync

# make sure the pods are running
kic pods

# check redis
kic check redis

# check heartbeat
kic check heartbeat

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

# force argo to sync
kic argo sync

# check for ArgoCD "Applications"
kic check argo

# wait for pods to start
kic pods

# check imdb
kic check imdb

```

## ArgoCD Dashboard

- `kic argo get-password`
  - copy the results to login to the dashboard
- Click on Ports tab
- Open ArgoCD-dashboard
- Login
  - admin
  - password from above

## Additional Member Clusters

- You can create additional Codespaces as member clusters
- Use a different Cluster name / directory for each cluster

> On the [GitHub Codespaces page](https://github.com/codespaces), you can change the name of the Codespace by clicking the `...`
