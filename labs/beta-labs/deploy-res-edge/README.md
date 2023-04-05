# Inner-loop with Res-Edge

This lab will go over steps to run Res-Edge in Codespaces.

This lab also builds on top of inner-loop lab. If you have not already done so, please run through the inner-loop lab [here](../../inner-loop.md#inner-loop) to get more familiarity with kic and other tools used in this lab.

## Create cluster in Codespaces

- Start in this directory

> The k3d cluster will run `in` your Codespace - no need for an external cluster

- Use `kic` to create and verify a new k3d cluster

```bash

# delete and create a new cluster
# ignore no-cluster error message
kic cluster create

kic pods

# wait for pods to get to Running
# Ctrl+C to exit
kic pods --watch

```

## Deploy SQL

- Now that we've created a new cluster, the next step is to deploy SQL Server database. Res-Edge data service requires a SQL Server database for start up. This database serves as an inventory storage for management of hierarchal groups, clusters, namespaces, and applications.

```bash

# create the namespace
kaf ns.yaml

# deploy sql server with sample data
k apply -k mssql

kic pods

# "watch" for the mssql pod to get to Running
# ctl-c to exit
kic pods --watch

# wait 30 seconds after the container is running for the data to load
kic check mssql

```

## Deploy data service

```bash

# deploy the data service
k apply -k api

# "watch" for the api pod to get to Running
# ctl-c to exit
kic pods --watch

# check api version to verify data service is running
kic check resedge

# "watch" for the api pod to get to Running
# ctl-c to exit
kic pods --watch

# check api version to verify data service is running
kic check resedge

```

## Load Test the data service

- Run a 5 second load test
  - Default `--duration` is 30 sec

```bash

# run test integration
kic test integration

# run load test
kic test load --verbose --duration 5
```

## Deploy WebV to Cluster

>Note: `<tab>` below means press the tab key for completion

```bash

# deploy webv
k apply -k webv

# "watch" for the webv pod to get to Running
# ctl-c to exit
kic pods --watch

# check to verify webv is running
kic check webv

# "watch" for the webv pod to get to Running
# ctl-c to exit
kic pods --watch

# check the logs
# todo - should we use K9s for this?
k logs -n api webv<tab>
k logs -n api api<tab>

```

## Deploy Observability

- Deploy the following observability stack in your cluster
  - Fluent Bit, Prometheus, Grafana

```bash

# deploy observability
k apply -k monitoring

# "watch" for the prometheus, fluentbit, grafana pod to get to Running
# ctl-c to exit
kic pods --watch

# check to verify prometheus, fluentbit, grafana is running
kic check prometheus
kic check fluentbit
kic check grafana

```

## Generate Requests for Observability

- Generate some traffic for the dashboards

```bash

# run a load test in the background
kic test load &

# run several integration tests
for i in {1..5}; kic test integration;

```

## Validate Observability

- use the ports tab to open Prometheus
  - look for custom ResEdge and WebV metrics

- use the ports tab to open Grafana
  - look at both dashboards

- run `k9s` to check Fluent Bit log forwarding
