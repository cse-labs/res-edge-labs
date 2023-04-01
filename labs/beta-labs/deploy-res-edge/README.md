# Deploy Res-Edge to Codespaces

- Start in this directory
- `<tab>` means press the tab key for completion

## Create cluster with access to private cse-labs registry

```bash

# delete existing cluster
# ignore no-cluster error message
kic cluster delete

# add github token for private registry
cp ../../../vm/setup/registries.templ "$HOME/bin/.kic/registries.yaml"
sed -i -e "s/{{pib-pat}}/$PIB_PAT/g" "$HOME/bin/.kic/registries.yaml"

# create the cluster
k3d cluster create \
  --registry-use k3d-registry.localhost:5500 \
  --registry-config "$HOME/bin/.kic/registries.yaml" \
  --config ".kic/k3d.yaml" \
  --k3s-arg "--disable=servicelb@server:0" \
  --k3s-arg "--disable=traefik@server:0"

# delete registries.yaml
rm -f "$HOME/bin/.kic/registries.yaml"

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
sql

# run a test query
select id,name from groups
go

exit

```

## Deploy data service

```bash

# deploy the data service
k apply -k api

kic pods

# wait for listening on 8080 log
k logs -n api api<tab>

```

## Test the data service

```bash

# curl the version endpoint
http localhost:30080/version

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
