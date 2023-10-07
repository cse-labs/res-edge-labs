# Assign Group to Namespace

> This lab is a prerequisite for the Kustomization and GitOps labs

- Application teams need to deploy their applicatons to specific clusters
- The `Groups`, `Namespaces`, and `Applications` are objects in the Res-Edge Data Service
- Res-Edge provides `GitOps Automation` to merge the objects via `GitOps` (Flux)

> In this lab, we will assign the `stores Group` to the `dogs-cats Namespace` which will result in the dogs-cats Namespace and Application being deployed to all 12 clusters via GitOps

## Prerequisites

- The Res-Edge Data Service needs to be deployed for this lab
  - Go to [Deploy Res-Edge Data Service lab](../deploy-res-edge.md#inner-loop-with-res-edge) to deploy the data service to the cluster

## Setup a clean environment

```bash

# start in the repo base directory
cd "$KIC_BASE"


# Warning: this will delete any existing data changes and they are not recoverable
ds reload --force

# run ci-cd locally
ds cicd

# deploy the clusters directory changes
ds deploy

```

## Verify that the data service is running

  ```bash

  ds check resedge

  ```

## Assign the Stores Group to the dogs-cats Namespace

- Get the Stores Group Id
  - The ds command will return 3

  ```bash

  ds search groups --query stores

  ```

- Get the dogs-cats Id
  - The ds command will return 4
    - It is coincidental that the Ids are the same

  ```bash

  ds search namespaces --query dogs-cats

  ```

- Use curl to assign the Group to the Namespace
  - You can use the Swagger UI as well
    - From the `ports` tab, open `Res-Edge (32080)`
      - Navigate to the Namespaces Section
      - Click on `Patch`
      - Click on `Try it out`

  ```bash

  # assign the stores Group to the Namespace
  # command will return a 200
  ds update namespace --id 4 --expression /g/stores

  ```

- Verify the Group was added to the Namespace

  ```bash

  ds show namespace --id 4 | grep expression

  ```

- Output should look like this

  ```json

  "expression": "/g/stores",

  ```

- Run cicd locally to verify changes

  ```bash

  ds cicd

  ```

- Check the status with git

  ```bash

  git status clusters

  ```

- Results
  - 3 files will be added to each cluster
    - The dogs-cats Namespace
    - The dogs-cats Application
    - The `Flux listener` for GitOps

- Commit the changes and push to the repo

  ```bash

  ds deploy

  ```

## Assign Groups to Namespaces

- Assign the following Groups to the tabs-spaces Namespace
  - beta
  - pilot

```bash

  # assign the Groups to the Namespace
  ds update namespace --id 5 --expression '/g/beta or /g/pilot'

  ```

- Verify the Groups were added to the Namespace

  ```bash

  ds show namespace --id 5 | grep expression

  ```

- Run cicd locally to verify changes

  ```bash

  ds cicd

  ```

- Check the status with git

  ```bash

  git status clusters

  ```

- Results
  - 6 clusters will have the tabs-spaces Namespace

- Remove Groups from Namespaces

  ```bash

  # unassign Groups from dog-cats and tabs-spaces Namespaces
  ds update namespace --id 4 --expression null
  ds update namespace --id 5 --expression null

  # run ci-cd locally
  ds cicd

  # no files should be dirty
  git status clusters

  ```

## Next Lab

- The next lab demonstrates ring deployment using Res-Edge and Kustomize
  - Go to the [Ring Deployment with Kustomize lab](../labs/ring-deployment-with-kustomize.md)
