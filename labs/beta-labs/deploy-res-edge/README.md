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

kic logs mssql

# "watch" for the mssql logs until data loads with log "# rows affected"
# ctl-c to exit
kic logs mssql --follow

# Verify mssql is loaded with metadata
kic check mssql

```

## Deploy data service

```bash

# deploy the data service
k apply -k api

kic pods

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

# run integration test
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

# check the logs
kic logs webv
kic logs api

```

## Deploy Observability

- Deploy the following observability stack in your cluster
  - Fluent Bit, Prometheus, Grafana

```bash

# deploy observability
k apply -k monitoring

kic pods

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

## Observability: Prometheus

- Prometheus is a de-facto standard for K8s metrics
- KiC deploys a Prometheus instance with `custom metrics` "in" your Codespace
- This is a powerful inner-loop feature as you don't have external dependencies
- See the [Prometheus documentation](https://prometheus.io/docs/introduction/overview/) for more information

### Open Prometheus in Your Browser

- From the `PORTS` tab, open `Prometheus (30000)`
- From the query window, enter `resedge`
  - This will filter to your custom app metrics
- From the query window, enter `webv`
  - This will filter to the WebValidate metrics

## Observability: Grafana

- Grafana is a de-facto standard for K8s dashboards
- KiC deploys a Grafana instance with custom dashboards "in" your Codespace
- This is a powerful inner-loop feature as you don't have external dependencies
- Explore the [Grafana documentation](https://grafana.com/docs/) to learn about more data sources, visualizations, and capabilities

### Open Grafana in Your Browser

- From the `PORTS` tab, open `Grafana (32000)`
  - Username: admin
  - Password: cse-labs
- Click on "General / Home" at the top of the screen and select "Application Dashboard" to see ResEdge application requests metrics
- Click on "General / Home" at the top of the screen and select "dotnet" to see ResEdge application health metrics

## Observability: Fluent Bit

- Fluent Bit is a de-facto standard for K8s log forwarding
  - KiC deploys a Fluent Bit instance with "in" your Codespace
- K9s is a commonly used UI that reduces the complexity of `kubectl`
  - KiC deploys k9s "in" your Codespace
- This is a powerful inner-loop feature as you don't have external dependencies
- See the [Fluent Bit documentation](https://docs.fluentbit.io/manual/) for more information on Fluent Bit
- See the [K9s documentation](https://k9scli.io/topics/commands/) for more information on K9s

### View Fluent Bit Logs in K9s

- Fluent Bit is set to forward logs to stdout for debugging
- Fluent Bit can be configured to forward to different services including Grafana Cloud or Azure Log Analytics

- Start `k9s` from the Codespace terminal

  ```bash

  k9s

  ```

- Press `0` to show all `namespaces`
- Select `fluentbit` pod and press `enter`
- Press `enter` again to see the logs
- Press `s` to Toggle AutoScroll
- Press `w` to Toggle Wrap
- Review logs that will be sent to Grafana when configured

> To exit K9s - `:q <enter>`
