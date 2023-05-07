# Assign Groups to Namespace

Application teams need to deploy their applicatons to specific clusters. The `Groups`, `Namespaces`, and `Applications` are entities in the Res-Edge Data Service. Res-Edge provides `GitOps Automation` to merge the entities via `GitOps` (Flux).

In this lab, we will assign the IMDb Namespace to the Stores Group which will result in the IMDb Namespace and Application being deployed to all 18 clusters in the Stores Group.

## Prerequisites

- The Res-Edge Data Service needs to be deployed for this lab
  - Go to [Deploy Res-Edge Data Service lab](../deploy-res-edge/README.md#inner-loop-with-res-edge) to deploy the data service to the cluster

## Start in the repo base directory

  ```bash

  cd $REPO_BASE

  ```

## Verify that the data service is running

  ```bash

  # check api version to verify Res-Edge Data Service is `Running`
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

  ```bash

  curl -i -X PUT http://localhost:32080/api/v1/namespaces/3/groups?expression=/g/stores

  ```

- Verify the Group was added to the Namespace

  ```bash

  ds namespaces show --id 3 | grep groupPaths -A 2

  ```

- Output should look like this

  ```json

  "groupPaths": [ "3" ]

  ```

- Run cicd locally to verify changes

  ```bash

  ds cicd

  ```

- Check the status with git

  ```bash

  git status

  ```
-

  ```bash



  ```
-

  ```bash



  ```
