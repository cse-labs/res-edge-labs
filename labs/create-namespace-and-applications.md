# Create a new Namespace and Applications

## Setup a clean environment

```bash

# This will delete any existing data changes and they are not recoverable
ds reload --force

# (optional) redeploy IMDb
ds namespaces set-expression --id 3 --expression /g/stores

# run ci-cd locally
ds cicd

# deploy the clusters directory changes
ds deploy

```

## Create a Namespace

- Create a new Namespace
- Assign the beta Group to the Namespace
- Note the Id of the Namespace as you'll need that later
  - It should be 20

- todo - fix expression bug
- "expression": "/g/beta",
- for now, run `ds namespaces set-expression --id 20 --expression /g/beta`
  - after you create the ns

- Open the Res-Edge app from the `Ports` tab
  - Expand Namespaces
  - Click on Post
  - Click on Try it out
  - Replace the sample json with the below json
  - Click Execute
  - Verify a 201 response code
  - Note the Id from the location header

    ```json

    {
        "name": "go-vote",
        "description": "go-vote namespace (demonstrates multiple apps in a ns)",
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

## Add Applications

- Update namespaceId to the go-vote ns Id if necessary
- NodePort must be unique and between 30081 and 30087 to deploy
- You can change the name, description, and metadata to create your own "this-or-that" app

- Open the Res-Edge app from the `Ports` tab
  - Expand Applications
  - Click on Post
  - Click on Try it out
  - Replace the sample json with the below json
  - Click Execute
  - Verify a 201 response code
  - Repeat for Application 2

## Application 1

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

## Application 2

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

# deploy the Cluster manifest
ds deploy

```
