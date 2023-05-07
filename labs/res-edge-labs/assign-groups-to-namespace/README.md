# Assign Groups to Namespace

## This lab is currently in beta

> This lab is a prerequisite for the Kustomization lab

- Application teams need to deploy their applicatons to specific clusters
- The `Groups`, `Namespaces`, and `Applications` are objects in the Res-Edge Data Service
- Res-Edge provides `GitOps Automation` to merge the objects via `GitOps` (Flux).

> In this lab, we will assign the Stores Group to the IMDb Namespace which will result in the IMDb Namespace and Application being deployed to all 18 clusters in the Stores Group via GitOps

## Prerequisites

- The Res-Edge Data Service needs to be deployed for this lab
  - Go to [Deploy Res-Edge Data Service lab](../deploy-res-edge/README.md#inner-loop-with-res-edge) to deploy the data service to the cluster

## Start in the repo base directory

  ```bash

  cd $REPO_BASE

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
    - It is strictly coincidental that the Ids are the same

  ```bash

  ds namespaces list --search imdb

  ```

- Use curl to assign the Group to the Namespace
  - You can use the Swagger UI instead
    - From the `ports` tab, open `Res-Edge (32080)`

  ```bash

  curl -i -X PATCH http://localhost:32080/api/v1/namespaces/3 -H 'Content-Type: application/json' -d '{ "expression": "/g/stores" }'

  # to unassign all groups from the namespace
  # curl -i -X PATCH http://localhost:32080/api/v1/namespaces/3 -H 'Content-Type: application/json' -d '{ "expression": null }'

  ```

- Verify the Group was added to the Namespace

  ```bash

  ds namespaces show --id 3 | grep groupPaths -A 2

  ```

- Output should look like this

  ```json

  "groupPaths": [ "3" ]

  ```

- todo - change the field name to "expression" and store the expression
  - new output will look like this

  ```json

  "expression": "/g/stores"

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
