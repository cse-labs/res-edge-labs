# Create a new Namespace and Applications

## Curl commands

```bash

```

## Namespace json

- Create a new Namespace
- Assign the beta Group to the Nsmespace
- Note the Id of the Namespace as you'll need that later
  - It should be 20 (unless you have created other Namespaces)

```json

{
  "expression": "/g/beta",
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

## Application1 json

- Update namespaceId to the go-vote ns Id if necessary
- NodePort must be unique and between 30081 and 30087 to deploy
- You can change the name, description, and metadata to create your own "this-or-that" app

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

## Application2 json

- Update namespaceId to the go-vote ns Id if necessary
- NodePort must be unique and between 30081 and 30087 to deploy
- You can change the name, description, and metadata to create your own "this-or-that" app

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
      "value": "Longhors"
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
