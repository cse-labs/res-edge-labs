# Assign Group to Namespace

## This lab is currently in beta

> This lab is a prerequisite for the Kustomization lab

- Application teams need to deploy their applicatons to specific clusters
- The `Groups`, `Namespaces`, and `Applications` are objects in the Res-Edge Data Service
- Res-Edge provides `GitOps Automation` to merge the objects via `GitOps` (Flux)

> In this lab, we will assign the `stores Group` to the `imdb Namespace` which will result in the IMDb Namespace and Application being deployed to all 18 clusters via GitOps

## Prerequisites

- The Res-Edge Data Service needs to be deployed for this lab
  - Go to [Deploy Res-Edge Data Service lab](../deploy-res-edge/README.md#inner-loop-with-res-edge) to deploy the data service to the cluster

## todo - beta tag

- Currently, you need to create a new cluster and deploy Res-Edge again (using the :beta tags)
- Before release, this will be converted to use the :0.9 tag

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

  # unassign all Groups from the Namespace (optional)
  curl -i -X PATCH http://localhost:32080/api/v1/namespaces/3 -H 'Content-Type: application/json' -d '{ "expression": null }'

  # assign the stores Group to the Namespace
  curl -i -X PATCH http://localhost:32080/api/v1/namespaces/3 -H 'Content-Type: application/json' -d '{ "expression": "/g/stores" }'

  # each command will return a 204 No Content

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

## Next Lab

- Next we will learn how to deploy to the IMDb app to all the clusters in the Stores Group
  - Go to the [Ring Deployment with Kustomize lab](../labs/ring-deployment-with-kustomize.md)
