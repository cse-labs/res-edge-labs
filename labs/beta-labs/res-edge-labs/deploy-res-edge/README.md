# Inner-loop with Res-Edge

- Res-Edge helps build a powerful system for automated deployment, update, management, and observability for thousands of Kubernetes clusters
- Res-Edge Data Service is a component of Res-Edge that enhances the experience of managing the complexity of applications deployments to Kubernetes environments at scale by providing a centralized inventory system which supports complex hierarchies
- This lab will go over steps to run Res-Edge Data Service with Observability in Codespaces
- To get more familiarity with kic and other tools used in this lab, please run through the inner-loop lab [here](../../../inner-loop.md#inner-loop)

## Create cluster in Codespaces

- Start in this lab directory

```bash

# cd to switch to deploy-res-edge directory
cd $REPO_BASE/labs/beta-labs/res-edge-labs/deploy-res-edge

```

- Use `kic` to create and verify a new k3d cluster

```bash

# delete and create a new cluster
# ignore no-cluster error message
kic cluster create

kic pods

# wait for pods to get to Running
# ctl-c to exit
kic pods --watch

```

> The k3d cluster will run `in` your Codespace - no need for an external cluster

## Deploy SQL

- Res-Edge Data Service requires a SQL Server database for start up
- This database serves as an inventory storage for management of hierarchical groups, clusters, namespaces, and applications
- When the container starts, it will populate the database with sample data
  - 19 Applications
  - 19 Clusters
  - 20 Hierarchical groups
  - 19 Namespaces
  - 3 Policies
  - All entities will have Metadata and Tags

> Note: `kaf` is an alias for `kubectl apply -f`, where `f` is for the manifest file path. `kak` is an alias for `kubectl apply -k`, where `k` is directory path for the kustomization.yaml. Run `alias` to view all aliases defined.

```bash

# create the namespace
kaf ns.yaml

# deploy SQL Server with sample data
kak mssql

kic pods

# "watch" for the mssql pod to get to Running
# ctl-c to exit
kic pods --watch

kic logs mssql

# "follow" the mssql logs until data loads with log "# rows affected"
# ctl-c to exit
kic logs mssql --follow

# Verify mssql is loaded with metadata
kic check mssql

```

## Deploy Res-Edge Data Service

- We will now deploy the Res-Edge Data Service
- This data service allows CRUD operations against the SQL Server database (Inventory storage) deployed from previous section

```bash

# deploy the Res-Edge Data Service
kak api

kic pods

# "watch" for the api pod to get to Running
# ctl-c to exit
kic pods --watch

# check api version to verify Res-Edge Data Service is `Running`
kic check resedge

```

## Test Res-Edge Data Service

- To make sure the Res-Edge Data Service is working properly, we will use `kic test` to generate both successful and failing requests
- `kic test` uses WebV installed in Codespace at start up

```bash

# run tests against Res-Edge Data Service
kic test all

```

## Query Res-Edge Data Service

- Run `kic [entity-type] list` to query the Res-Edge Data Service and return all entities in this data service

> To dive deeper into these commands and learn more about filtering results, go to [Query Res-Edge Data Service](./query-res-edge-data.md)

```bash

# example commands
kic applications list
kic namespaces list
kic clusters list
kic groups list
kic policies list

```

- Run `kic [entity-type] show --id [entity-id]` to return a specific entity's information

```bash

# To get the beta group id
kic groups list --search beta

# Insert the above id in [entity-id] to
kic groups show --id 2

# example commands
kic applications show --id 2
kic namespaces show --id 2
kic clusters show --id 2
kic groups show --id 2
kic policies show --id 2

```

## Deploy Observability

- Next we will deploy the following observability stack in your cluster
  - Fluent Bit, Prometheus, Grafana

```bash

# deploy observability
kak monitoring

kic pods

# "watch" for the prometheus, fluentbit, grafana pod to get to Running
# ctl-c to exit
kic pods --watch

# check to verify prometheus, fluentbit, grafana is running
kic check prometheus
kic check fluentbit
kic check grafana

```

## Deploy WebV

- To generate dashboard metrics we will deploy WebV to the cluster
- This will continuously generate 10 requests per second

```bash

# deploy webv
kak webv

# "watch" for the webv pod to get to Running
# ctl-c to exit
kic pods --watch

# check to verify webv is running
kic check webv

# check the logs, you should see requests logs
# alternatively, you can use k9s
kic logs webv
kic logs resedge

```

## Observability: K9s

- K9s is a commonly used UI that reduces the complexity of `kubectl`
  - KiC deploys K9s "in" your Codespace
- See the [K9s documentation](https://k9scli.io/topics/commands/) for more information on K9s

### View Logs in K9s

- Start `k9s` from the Codespace terminal

```bash

# start k9s
k9s

```

- Press `0` to show all `namespaces`
- Select `api` pod and press `l` to review the Res-Edge Data Service logs
- Press `s` to Toggle AutoScroll
- Press `w` to Toggle Wrap
- Press `esc` to return to Pod View
- Select `webv` pod and press `l` to review the WebV logs
- Press `esc` to return to Pod View
- Select `fluentbit` pod and press `l` to see the Fluent Bit logs

> To exit K9s - `:q <enter>` or `ctl-c`

## Observability: Fluent Bit

- Fluent Bit is set to forward logs to stdout for debugging
- Fluent Bit can be configured to forward to different services including [Loki](https://grafana.com/oss/loki/) or [Azure Log Analytics](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-overview)
- This is a powerful inner-loop feature as you don't have external dependencies
- See the [Fluent Bit documentation](https://docs.fluentbit.io/manual/) for more information on Fluent Bit

## Observability: Prometheus

- Prometheus is a de-facto standard for K8s metrics
- We have deployed a Prometheus instance with `custom metrics`
- This is a powerful inner-loop feature as you don't have external dependencies
- See the [Prometheus documentation](https://prometheus.io/docs/introduction/overview/) for more information

### Open Prometheus in Your Browser

- From the `PORTS` tab, open `Prometheus (30000)`
- From the query window, enter `resedge`
  - This will filter to your custom app metrics
- From the query window, enter `webv`
  - This will filter to the WebV metrics

## Observability: Grafana

- Grafana is a de-facto standard for K8s dashboards
- We have deployed a Grafana instance with custom dashboards
- This is a powerful inner-loop feature as you don't have external dependencies
- Explore the [Grafana documentation](https://grafana.com/docs/) to learn about more data sources, visualizations, and capabilities

### Open Grafana in Your Browser

- From the `PORTS` tab, open `Grafana (32000)`
  - Username: admin
  - Password: cse-labs
- Click on "General / Home" at the top of the screen and select "dotnet" to see Res-Edge Data Service health metrics
- Click on "General / Home" at the top of the screen and select "Application Dashboard" to see Res-Edge Data Service requests metrics
- You should see the Application Dashboard with both WebV and Res-Edge Data Service ("Application").
  - WebV will have 10 requests per second.
  - Application will have 10.2 requests per second
    - K8s calls /healthz every minute
    - Prometheus calls /metrics every 5 seconds
    - WebV has 10 requests per second
- Keep "Application Dashboard" open in a browser tab to monitor Res-Edge Data Service requests metrics for the next section. The version number of Res-Edge Data Service and WebV will appear below "Application" and "WebV" accordingly.

### Generate More Requests for Observability using WebV

- Generate load test for 30 seconds

```bash

# run a load test in the background to see a spike of 60 requests/sec for the Application Requests section
kic test load &

```

- Generate both successful and failing requests

```bash

# run several integration tests to see a spike in Error Graph Section
kic test all

```
