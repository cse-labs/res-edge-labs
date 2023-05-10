# GitOps

## Create a new Codespace

- for testing, you can use the same Codespace
- if you do, you will need to recreate your cluster
  - deploy res-edge
  - assign group to namespace
  - run `ds cicd`
  - push to git repo

## Set Personal Access Token

```bash

export KIC_PAT=<yourGitHubPAT>

```

## Set environment variables

- Set any of these env vars that are not set correctly

```bash

echo $KIC_FULL_REPO

echo $KIC_PAT

echo $KIC_BRANCH

```

## Create a New Cluster

- Use `kic` to create and verify a new k3d cluster in the new Codespace

```bash

# delete and create a new cluster
kic cluster create

# wait for pods to get to Running
kic pods --watch

```

## Deploy GitOps (Flux v2)

- This deploys GitOps (Flux) to your cluster

```bash

cd "$REPO_BASE/clusters/central-la-nola-2301/flux-system"

# deploy the Flux components
kubectl apply -f components.yaml

# create the Flux secret
flux create secret git flux-system -n flux-system --url "$KIC_FULL_REPO" -u gitops -p "$KIC_PAT"

# create the Flux Source
kubectl apply -f source.yaml

# create the Flux Kustomization
kubectl apply -f flux-kustomization.yaml

# check the source and kustomizations
flux get all

# check the kustomizations
# todo - change kic check flux to flux get all instead of flux get kustomizations
kic check flux

```

## Force Flux to Sync

- After making changes, you can force Flux to sync (reconcile)

```bash

# todo - this is currently broken
kic sync

```

## Verify Flux Deployment

```bash

# make sure the pods are running
kic check pods --watch

# check heartbeat
kic check heartbeat

# check imdb
kic check imdb

```

## Flux Setup Files

> todo - this needs to be updated

- The Flux setup yaml is located in `apps/myapp/kic-deploy/flux`
  - A `Flux source` is a git repo / branch combination
  - A `Flux kustomization` is a directory within the source
    - We have 3 kustomizations
      - kustomization-flux watches the flux directory
      - kustomization-app watches the app directory
      - kustomization-monitoring watches the monitoring directory
    - You want to have multiple kustomizations (or helm)
      - When a kustomization fails, the entire process is aborted
        - This lets "your app" break "my app"
      - We generally create a kustomization per namespace for production
        - Our GitOps Automation (outer-loop) automatically creates a kustomization per namespace
- View the flux setup script by running `kic cluster flux-install --show`
