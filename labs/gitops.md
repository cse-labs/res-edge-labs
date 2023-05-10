# GitOps

## Create a new Codespace

## Create a New Cluster

- Use `kic` to create and verify a new k3d cluster in the new Codespace

```bash

# delete and create a new cluster
kic cluster create

# wait for pods to get to Running
kic pods --watch

```

## Deploy MyApp and Observability with GitOps (Flux v2)

> Notice you don't have to create or edit K8s YAML files!

- This deploys GitOps (Flux) to your cluster

```bash

# deploy flux to the cluster
kic cluster flux-install

# wait for pods to start
kic pods --watch

# check flux
kic check flux

```

## Force Flux to Sync

- After making changes, you can force Flux to sync (reconcile)

```bash

kic sync

```

## Flux Setup Files

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
