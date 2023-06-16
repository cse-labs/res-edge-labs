# GitOps Lab (ArgoCD)

- In this lab, we will use GitOps (ArgoCD) to deploy the Namespaces and Applications assigned to a Cluster
  - We refer to this Cluster as a "member cluster"
    - Member clusters can be listed with the `ds clusters list` command
    - We will use `central-la-nola-2301` as our member cluster name
      - You can use any cluster in the list

## Prerequisites

- Deploy the Res-Edge [data service](./deploy-res-edge.md)
- Assign a Group to the [imdb Namespace](./assign-group-to-namespace.md)

## Setup a clean environment

```bash

# start in the repo base directory
cd "$KIC_BASE"

# Warning: this will delete any existing data changes and they are not recoverable
ds reload --force

# redeploy IMDb
# will return 204 No Content
ds set-expression --id 3 --expression /g/stores

# update GitOpsRepo and Branch
# todo - use the API
sql -Q "update Clusters set GitOpsRepo='$KIC_REPO_FULL', GitOpsBranch = '$KIC_BRANCH'; select GitOpsRepo, GitOpsBranch from Clusters"

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

## Set Env Vars

- We use the GITHUB_TOKEN for Flux connectivity for convenience
  - The GITHUB_TOKEN will expire about a week after the Codespace is created
  - GitOps will fail once the token expires

```bash

export KIC_REPO_FULL=$(git remote get-url --push origin)
export KIC_BRANCH=$(git branch --show-current)

if [ "$KIC_PAT" = "" ]; then
  export KIC_PAT=$GITHUB_TOKEN
fi

kic env

```

- For long running GitOps, you need to create a GitHub Personal Access Token (PAT)
  - `export KIC_PAT=<YourGitHubPat>`
- Update `$HOME/kic.env` to make your GitHub PAT persistent across shells

## Deploy GitOps (ArgoCD)

- This deploys GitOps (ArgoCD) to your cluster

```bash

# change central-la-nola-2301 to deploy additional member clusters
cd "$KIC_BASE/clusters/central-la-nola-2301/argocd"

# deploy argo
kubectl apply -k .

```

## Verify ArgoCD Deployment

- Argo should create 3 new Namespaces
  - heartbeat
  - imdb
  - redis

```bash

# check for ArgoCD "Applications"
kubectl get application -n argocd

# make sure the pods are running
kic pods --watch

# check heartbeat
kic check heartbeat

# check imdb
kic check imdb

# check redis
kic check redis

```

## Additional Member Clusters

- You can create additional Codespaces as member clusters
- Use a different Cluster name / directory for each cluster

> On the [GitHub Codespaces page](https://github.com/codespaces), you can change the name of the Codespace by clicking the `...`
