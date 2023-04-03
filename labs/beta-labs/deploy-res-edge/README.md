# Deploy Res-Edge to Codespaces

- Start in this directory
- `<tab>` means press the tab key for completion

## Create cluster with access to private cse-labs registry

- todo - need to add instructions for using an actual PAT instead of the temporary GITHUB_TOKEN
  - the token expires (every 10 days I think)
  - this will cause image pull errors

```bash

# this will delete existing cluster
# ignore no-cluster error message
kic cluster create

# wait for pods to start
kic pods

```

## Deploy SQL

```bash

# create the namespace
kaf ns.yaml

# deploy sql server
k apply -k mssql

# verify sql started
kic pods

# wait 30 seconds after the container is running for the data to load
sql -Q "select id,name from clusters;"

```

## Deploy data service

```bash

# deploy the data service
k apply -k api

kic pods

# wait for listening on 8080 log
# todo - should we use K9s for this?
k logs -n api api<tab>

```

## Test the data service

```bash

# curl the version endpoint
http localhost:32080/version

# run kic test
kic test integration
kic test load --verbose --duration 5

```

## Deploy WebV

```bash

# deploy webv
k apply -k webv

kic pods

# check the logs
# todo - should we use K9s for this?
k logs -n api webv<tab>
k logs -n api api<tab>

```

## Deploy Observability

```bash

# deploy observability
k apply -k monitoring

kic pods

# generate some dashboard metrics
kic test load &
kic test integration
kic test integration
kic test integration
kic test integration
kic test integration

```

## Validate Observability

- use the ports tab to open Prometheus
  - look for custom ResEdge and WebV metrics

- use the ports tab to open Grafana
  - look at both dashboards

- run `k9s` to check Fluent Bit log forwarding
