# Inner-loop with Res-Edge

This lab will go over steps to run Res-Edge in codespaces.
Res-Edge, which stands for Resilient Edge, helps deploy apps in a performant and scalable way to k8s clusters. If interested, please read over Res-Edge for more information [here](https://github.com/cse-labs/Project100k).

This lab also builds on top of inner-loop lab. If you haven't already done so, please run through inner-loop lab [here](../../inner-loop.md#) to get more familiarity on kic and other tools used in this lab.

## Setup

- Start in this directory.
- [Create a PAT](https://docs.github.com/en/enterprise-server@3.4/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) with repo access and read package permission to cse-labs. Another option is to create a shared Github PAT as described [here](../../azure-codespaces-setup.md#shared-personal-access-token).
- Set the environment PIB_PAT to the PAT created above.
- Download WebV image, if not already installed.

```bash
# Docker login with PAT acccess to cse-labs.
echo $PIB_PAT | docker login ghcr.io -u USERNAME --password-stdin

# Download webv image.
docker pull ghcr.io/cse-labs/res-edge-webv:beta
```

## Create cluster with access to private cse-labs registry

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

# deploy sql server with sample data
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

```

## Test the data service

```bash

# curl the version endpoint
http localhost:32080/version

# run tests
kic test integration
kic test load --verbose --duration 5

```

## Deploy WebV

>Note: `<tab>` below means press the tab key for completion

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
