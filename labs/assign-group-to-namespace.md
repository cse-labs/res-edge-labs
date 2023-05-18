# Assign Group to Namespace

> This lab is a prerequisite for the Kustomization and GitOps labs

- Application teams need to deploy their applicatons to specific clusters
- The `Groups`, `Namespaces`, and `Applications` are objects in the Res-Edge Data Service
- Res-Edge provides `GitOps Automation` to merge the objects via `GitOps` (Flux)

> In this lab, we will assign the `stores Group` to the `imdb Namespace` which will result in the IMDb Namespace and Application being deployed to all 18 clusters via GitOps

## Prerequisites

- The Res-Edge Data Service needs to be deployed for this lab
  - Go to [Deploy Res-Edge Data Service lab](../deploy-res-edge/README.md#inner-loop-with-res-edge) to deploy the data service to the cluster

## Start in the repo base directory

  ```bash

  cd $KIC_BASE

  ```

## Verify that the data service is running

  ```bash

  kic check resedge

  ```

## Assign the Stores Group to the IMDb Namespace

- Get the Stores Group Id
  - The ds command will return 3

  ```bash

  ds groups list --search stores

  ```

- Get the IMDb Id
  - The ds command will return 3
    - It is coincidental that the Ids are the same

  ```bash

  ds namespaces list --search imdb

  ```

- Use curl to assign the Group to the Namespace
  - You can use the Swagger UI as well
    - From the `ports` tab, open `Res-Edge (32080)`
      - Navigate to the Namespaces Section
      - Click on `Patch`
      - Click on `Try it out`

  ```bash

  # assign the stores Group to the Namespace
  # command will return a 204
  ds namespaces set-expression --id 3 --expression /g/stores

  ```

- Verify the Group was added to the Namespace

  ```bash

  ds namespaces show --id 3 | grep expression

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

  git status

  ```

- Results
  - 3 files will be added to each cluster
    - The IMDb Namespace
    - The IMDb Application
    - The `Flux listener` for GitOps

- Commit the changes and push to the repo

  ```bash

  git add .
  git commit -am "assigned Stores Group to IMDb Namespace"
  git push

  ```

## Assign Groups to Namespaces

- Assign the following Groups to the dogs-cats Namespace
  - atx (8)
  - sea (18)
- Assign the following Groups to the tabs-spaces Namespace
  - beta (1)
  - pilot (2)

```bash

  # assign the Groups to the Namespace
  ds namespaces set-expression --id 4 --expression /g/stores/central/tx/atx or /g/stores/west/wa/sea
  ds namespaces set-expression --id 5 --expression /g/beta or /g/pilot

  ```

- Verify the Groups were added to the Namespace

  ```bash

  ds namespaces show --id 4 | grep expression
  ds namespaces show --id 5 | grep expression

  ```

- Run cicd locally to verify changes

  ```bash

  ds cicd

  ```

- Check the status with git

  ```bash

  git status

  ```

- Results
  - 6 clusters will have the dogs-cats Namespace
  - 6 clusters will have the tabs-spaces Namespace

- Remove Groups from Namespaces

  ```bash

  # unassign Groups from dog-cats and tabs-spaces Namespaces
  ds namespaces set-expression --id 4 --expression null
  ds namespaces set-expression --id 5 --expression null

  # run ci-cd locally
  ds cicd

  # no files should be dirty
  git status

  ```

## Next Lab

- The next lab demonstrates ring deployment using Res-Edge and Kustomize
  - Go to the [Ring Deployment with Kustomize lab](../labs/ring-deployment-with-kustomize.md)
