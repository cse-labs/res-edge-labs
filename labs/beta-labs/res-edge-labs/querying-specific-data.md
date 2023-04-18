# Querying Specific Data

- Run `kic [entity-type] list` to query the data service and return a filtered list with the following options:
> Note: All options for `list` are optional

```bash

# This option allows the user to perform an exact search on the entity name, tags, or metadata (eg. `imdb`, `west`)
--search [search-term]

# This option allows the user to sort the results returned by the `list` by name or id. The default sort is by id.
--order-by [name/id]

# example command
kic applications list --search west --order-by name
kic namespaces list --search imdb
kic policies list --order-by id

```

- An additional option exists pecifically for groups and clusters. This option does not work with `--search` or `--order-by` and should be entered alone:

```bash

# Returns a list of clusters in the specified group (eg. `beta`)
--group [group-name]

# example command
kic clusters --group beta
kic groups --group west

```

- Run `kic [entity-type] show` to return a specific entity's information:

```bash

# Returns entity information for the passed in id
--id

#example command
kic clusters show --id 2

```
