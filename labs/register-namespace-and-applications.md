# Register a new Namespace and Applications

- Application teams need to register new Namespaces and Applications in the Res-Edge Data Service
- `Groups`, `Namespaces`, and `Applications` are objects in the Res-Edge Data Service
- Res-Edge provides `GitOps Automation` to merge the objects via `GitOps` (Flux)

> In this lab, we will register a new Namespace and two new Applications to the Data Service

- This lab introduces the `Swagger UI` to update the data service

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

## Register a Namespace

- Register a new Namespace in the Data Service

  - Open the Res-Edge app from the `Ports` tab
    - Expand Namespaces
    - Click on Post
    - Replace the sample json with the below json
    - Click Execute
    - Verify a 201 response code
    - Note the Id from the location header as you'll need that later
      - It should be `20`

## Namespace json

```json

{
    "name": "go-vote",
    "description": "go-vote namespace (demonstrates multiple apps in a ns)",
    "expression": "/g/beta",
    "tags": [ "go-vote" ],
    "businessUnit": "Platform",
    "environment": "Prod",
    "capacity": {
        "memoryLimit": 512,
        "cpuLimit": 1.0
    },
    "metadata": [
        {
        "key": "type",
        "value": "go-vote"
        }
    ]
}

```

## Register Applications

- You can change the name, description, and metadata to create your own "this-or-that" app
  - NodePort must be unique and between 30081 and 30087 to deploy

- Open the Res-Edge app from the `Ports` tab
  - Expand Applications
  - Click on Post
  - Replace the sample json with the below json
  - Click Execute
  - Verify a 201 response code
  - Repeat for Application 2

## Application json

```json

{
  "namespaceId": 20,
  "name": "shaken-stirred",
  "description": "Bond. James Bond.",
  "environment": "Prod",
  "repoUrl": "/github.com/cse-labs/test",
  "pat": "/cse-labs",
  "path": "/apps/go-vote",
  "businessUnit": "Platform",
  "owner": "platform",
  "tags": ["go-vote" ],
  "capacity": {
    "memoryLimit": 64,
    "cpuLimit": 0.25
  },
  "metadata": [
    {
      "key": "choice1",
      "value": "Shaken"
    },
    {
      "key": "choice2",
      "value": "Stirred"
    },
    {
      "key": "go-vote",
      "value": "shaken-stirred"
    },
    {
      "key": "title",
      "value": "Bond. James Bond."
    },
    {
      "key": "nodePort",
      "value": "32081"
    },
    {
      "key": "type",
      "value": "go-vote"
    }
  ]
}

```

## Application 2 json

```json

{
  "namespaceId": 20,
  "name": "longhorns-aggies",
  "description": "Texas Football",
  "environment": "Prod",
  "repoUrl": "/github.com/cse-labs/test",
  "pat": "/cse-labs",
  "path": "/apps/go-vote",
  "businessUnit": "Platform",
  "owner": "platform",
  "tags": ["go-vote" ],
  "capacity": {
    "memoryLimit": 64,
    "cpuLimit": 0.25
  },
  "metadata": [
    {
      "key": "choice1",
      "value": "Longhorns"
    },
    {
      "key": "choice2",
      "value": "Aggies"
    },
    {
      "key": "go-vote",
      "value": "longhorns-aggies"
    },
    {
      "key": "title",
      "value": "Texas Football!"
    },
    {
      "key": "nodePort",
      "value": "32082"
    },
    {
      "key": "type",
      "value": "go-vote"
    }
  ]
}

```

## Generate the Cluster manifests

```bash

# run ci-cd locally
ds cicd

# check the changes
git status

# deploy the Cluster manifest via GitOps
ds deploy

```
