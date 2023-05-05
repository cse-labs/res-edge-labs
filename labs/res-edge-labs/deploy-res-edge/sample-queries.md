# Sample Data Service Queries

> The CLI commands are in `preview` and will likely change before final release

- The `kic CLI` implements basic commands to query the `Data Service`
- Additional CLI commands and a web user interface are planned for future releases

## Data Service Objects

The `Data Service` exposes the following entities via a REST/OData interface

- Application - represents an application `registered` by an application development team
  - An Application belongs to zero or one Namespace
- Cluster - represents a K8s physical cluster
  - Namespaces are assigned to a Cluster directly or via Group membership
  - `GitOps Automation` uses the Cluster + Namespaces to generate the K8s deployment manifests that are applied by `Flux`
- Group - a grouping of clusters to allow managing as a group instead of individually
  - A Group can contain `sub-Groups` in a hierarchical manner
  - The list of `Clusters` in a group contains the clusters assigned to the group as well as any clusters assigned to descendant groups
- Namespace - represents a Kubernetes namespace that can be deployed to cluster(s)
  - Applications belong to a Namespace
  - Namespace can be assigned to zero, one, or many Groups
- Policy - represents a policy that is stored in the GitOps repo
  - Policies are assigned to Namespaces

## List Entities

- Return a simple list of Entity ID and Name

```bash

kic applications list
kic clusters list
kic groups list
kic namespaces list
kic policies list

# order by name
# default order-by is Id
kic applications list --order-by name
kic clusters list --order-by name
kic groups list --order-by name
kic namespaces list --order-by name
kic policies list --order-by name

```

## Search Entities

- Return a simple list of Entity ID and Name where one or more of the following is true
  - `Name` equals search term
  - A `Tag` exists that equals the search term
  - A `MetaData Value` exists that equals the search term
- Comparisons are exact and case sensitive
- --order-by name is an optional argument

```bash

kic applications list --search imdb
kic clusters list --search central
kic groups list --search beta
kic namespaces list --search imdb
kic policies list --search no-ingress

```

## Group Membership

- Return a simple list of Entity ID and Name where the Group is assigned to the entity
  - Additional parameters are not currently supported

```bash

kic clusters list --group beta
kic groups list --group west

```

- example output for `kic clusters list --group beta`

```text

central-la-nola-2301
east-ga-atl-2301
west-ca-sd-2301

```

## Get Entity by Id

- Show the entity values
  - Result format is json
  - --id is required

    ```bash

    kic applications show --id 6
    kic clusters show --id 2
    kic groups show --id 2
    kic namespaces show --id 6
    kic policies show --id 2

    ```

- Output for `kic applications show --id 6`

  ```json

  {
    "@odata.context": "http://localhost:32080/api/v1/$metadata#Applications(namespace())/$entity",
    "id": 6,
    "name": "tabs-spaces",
    "description": "Can we still be friends?",
    "environment": "Prod",
    "namespaceId": 6,
    "repoUrl": "/github.com/cse-labs/test",
    "pat": "/cse-labs",
    "path": "/apps",
    "businessUnit": "Platform",
    "owner": "platform",
    "capacity": {
      "memoryLimit": 64,
      "cpuLimit": 0.25
    },
    "tags": [
      "Can we still be friends?",
      "go-vote",
      "Spaces",
      "Tabs",
      "tabs-spaces"
    ],
    "metadata": [
      {
        "key": "Choice1",
        "value": "Tabs"
      },
      {
        "key": "Choice2",
        "value": "Spaces"
      },
      {
        "key": "go-vote",
        "value": "tabs-spaces"
      },
      {
        "key": "Title",
        "value": "Can we still be friends?"
      },
      {
        "key": "type",
        "value": "go-vote"
      }
    ],
    "namespace": {
      "id": 6,
      "name": "tabs-spaces",
      "description": "Can we still be friends?",
      "businessUnit": "Platform",
      "environment": "Prod",
      "capacity": {
        "memoryLimit": 64,
        "cpuLimit": 0.25
      },
      "tags": [
        "Can we still be friends?",
        "go-vote",
        "Spaces",
        "Tabs",
        "tabs-spaces"
      ],
      "metadata": [
        {
          "key": "Choice1",
          "value": "Tabs"
        },
        {
          "key": "Choice2",
          "value": "Spaces"
        },
        {
          "key": "go-vote",
          "value": "tabs-spaces"
        },
        {
          "key": "Title",
          "value": "Can we still be friends?"
        },
        {
          "key": "type",
          "value": "go-vote"
        }
      ]
    }
  }

  ```
