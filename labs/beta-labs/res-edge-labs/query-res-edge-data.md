# Query Res-Edge Data

- Run `kic [entity-type] list` to query the Res-Edge Data Service and return a filtered list with the following options:

> Note: All options for `list` are optional

```bash

# This option allows the user to perform an exact search on the entity name, tags, or metadata (eg. `imdb`, `west`) and will return all the information for any matches.
--search [search-term]

# This option allows the user to sort the results returned by the `list` by name or id.
# If not passed in, the default sort will be by id.
--order-by [name]

# example commands
kic groups list --search west --order-by name
kic namespaces list --search imdb
kic policies list --order-by name

```

- An additional option exists specifically for groups and clusters. This option does not work with `--search` or `--order-by` and should be entered alone:

```bash

# Returns a list of the names of clusters in the specified group (eg. `beta`)
--group [group-name]

# example commands
kic clusters list --group beta
kic groups list --group west

# example output for kic clusters list --group beta
central-la-nola-2301
east-ga-atl-2301
west-ca-sd-2301
```

- Run `kic [entity-type] show --id [entityId]` to return a specific entity's information:
> Note: `--id` is a required field

```bash

# Returns entity information for the passed in id
--id

# example commands
kic applications show --id 2
kic namespaces show --id 2
kic clusters show --id 2
kic groups show --id 2
kic policies show --id 2

# example output for kic applications show --id 2
{
  "@odata.context": "http://localhost:32080/api/v1/$metadata#Applications(namespace())/$entity",
  "environment": "Prod",
  "namespaceId": 2,
  "repoUrl": "/github.com/cse-labs/test",
  "pat": "/cse-labs",
  "path": "/apps",
  "businessUnit": "Platform",
  "owner": "platform",
  "id": 2,
  "name": "heartbeat",
  "description": "Node heartbeat",
  "tags": [],
  "createdOn": "2023-04-19T17:09:15.7833333Z",
  "createdBy": "dbo",
  "updatedOn": "2023-04-19T17:09:15.7833333Z",
  "updatedBy": "dbo",
  "capacity": {
    "memoryLimit": 64,
    "cpuLimit": 0.25
  },
  "metadata": [],
  "namespace": {
    "businessUnit": "Platform",
    "environment": "Prod",
    "groupPaths": [
      "1",
      "4"
    ],
    "id": 2,
    "name": "heartbeat",
    "description": "Node heartbeat",
    "tags": [],
    "createdOn": "2023-04-19T17:09:15.6433333Z",
    "createdBy": "dbo",
    "updatedOn": "2023-04-19T17:09:15.6433333Z",
    "updatedBy": "dbo",
    "capacity": {
      "memoryLimit": 64,
      "cpuLimit": 0.25
    },
    "metadata": []
  }
}
```
