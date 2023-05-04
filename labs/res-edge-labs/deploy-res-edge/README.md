# Inner-loop with Res-Edge

- Res-Edge helps build a powerful system for automated deployment, update, management, and observability for thousands of Kubernetes (K8s) clusters
- Res-Edge Data Service is a component of Res-Edge that enhances the experience of managing the complexity of applications deployments to K8s environments at scale by providing a centralized inventory system which supports complex hierarchies
- This lab will go over steps to run Res-Edge Data Service with Observability in Codespaces
- To get more familiarity with kic and other tools used in this lab, please run through the inner-loop lab [here](../../inner-loop.md#inner-loop)

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

  # wait for pods to get to 1/1 Running
  # ctl-c to exit
  kic pods --watch

  ```
  > The `--watch` flag will update the last line in the terminal output. Wait for the last line to read 'Running' after the 'ContainerCreating' status then `ctrl-c` to exit

  > The k3d cluster will run `in` your Codespace - no need for an external cluster

## Deploy SQL

- In this section, we will deploy SQL Server to the local K8s cluster
- Res-Edge Data Service requires a SQL Server database for start up
- This database serves as an inventory storage for management of groups, clusters, namespaces, and applications
- When the container starts, it will populate the database with sample data
  - 19 Applications
  - 19 Clusters
  - 19 Groups
  - 19 Namespaces
  - 3 Policies
  - All entities will have Metadata and Tags
- Run `alias` to view all aliases defined
  - `kaf` is an alias for `kubectl apply -f`, where `f` is for the manifest file path
  - `kak` is an alias for `kubectl apply -k`, where `k` is directory path for the kustomization.yaml
  - To create a new alias for your current terminal session, run `alias [alias-name]='[command]'`

  ```bash

  # create the namespace
  kaf ns.yaml

  # deploy SQL Server with sample data
  kak mssql

  kic pods

  # "watch" for the mssql pod to get to 1/1 Running
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
- This data service is the interface to the SQL Server database deployed in the previous section and uses a REST/OData API to perform CRUD operations

  ```bash

  # deploy the Res-Edge Data Service
  kak api

  kic pods

  # "watch" for the api pod to get to 1/1 Running
  # ctl-c to exit
  kic pods --watch

  # check api version to verify Res-Edge Data Service is `Running`
  kic check resedge

  ```

## Test Res-Edge Data Service

- To make sure the Res-Edge Data Service is working properly, we will use `kic test` to generate both successful and failing requests
- `kic test` uses WebValidate installed in Codespace at start up. For more information on WebV, see [here](https://github.com/microsoft/webvalidate)

  > Note: Failing 400 and 404 requests are run in `kic test all` by design. For the number of errors, refer to the summary at the bottom. "Errors 0" indicate all tests passed.

  ```bash

  # run tests against Res-Edge Data Service
  kic test all

  ```

## Query Res-Edge Data Service

> To dive deeper into these commands and learn more about filtering results, go to [Query Res-Edge Data Service](./query-res-edge-data.md)

- Run `kic [entity-type] list` to query the Res-Edge Data Service and return all entities in this data service
- Run `kic [entity-type] list --search [entity-name]` to return a list of entities that have an exact match for the search term on the name, metadata, or tags fields.

  ```bash

  # To list all applications
  kic applications list

  # To list all applications where the name, tags, or metadata values match 'imdb'
  kic applications list --search imdb

  # To list all namespaces
  kic namespaces list

  # To list all namespaces where the name, tags, or metadata values match 'imdb'
  kic namespaces list --search imdb

  # To list all clusters
  kic clusters list

  # To list all clusters where the name, tags, or metadata values match 'central-la-nola-2301'
  kic clusters list --search central-la-nola-2301

  # To list the available policies
  kic policies list

  # To list all policies where the name, tags, or metadata values match 'dns-ingress'
  kic policies list --search dns-ingress

  # To list all groups
  kic groups list

  # To list all groups where the name, tags, or metadata values match 'beta'
  # This will return the id we will use in the show command next
  kic groups list --search beta

  ```

- Run `kic [entity-type] show --id [entity-id]` to return a specific entity's information

  ```bash

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
- Prometheus scrapes these logs every 5 seconds and exports them to the Grafana dashboard, which we will open later in the lab

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

## Observability

### K9s

- KiC deploys K9s "in" your Codespace
- K9s is a commonly used UI that reduces the complexity of `kubectl` that:
  - continually watches K8s for changes and has commands to interact with resources
  - tracks cluster metrics and displays logs of deployed applications
- See the [K9s documentation](https://k9scli.io/topics/commands/) for more information on K9s

### Fluent Bit

- Fluent Bit is set to forward logs to stdout for debugging
- Fluent Bit can be configured to forward to different services including [Loki](https://grafana.com/oss/loki/) or [Azure Log Analytics](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-overview)
- This is a powerful inner-loop feature as you don't have external dependencies
- See the [Fluent Bit documentation](https://docs.fluentbit.io/manual/) for more information on Fluent Bit

### Prometheus

- Prometheus is a de-facto standard for K8s metrics
- We have deployed a Prometheus instance with `custom metrics`
- This is a powerful inner-loop feature as you don't have external dependencies
- See the [Prometheus documentation](https://prometheus.io/docs/introduction/overview/) for more information

### Grafana

- Grafana is a de-facto standard for K8s dashboards
- We have deployed a Grafana instance with custom dashboards
- This is a powerful inner-loop feature as you don't have external dependencies
- Explore the [Grafana documentation](https://grafana.com/docs/) to learn about more data sources, visualizations, and capabilities

### Observability in Action

#### View Logs in K9s

```bash

# Start `k9s` from the Codespace terminal
k9s

```

- Press `0` to show all `namespaces`
- Select `api` pod and press `l` to review the Res-Edge Data Service logs
  - We should see the following successful (statusCode 200) logs:
    - K8s healthcheck every minute
    - Prometheus scrape to /metrics logs every 5 seconds
    - 10 GET requests from WebV every second
- Press `esc` to return to Pod View
- Select `webv` pod and press `l` to review the WebV logs
  - We should see 10 successful 200 requests per second
- Press `esc` to return to Pod View
- Select `fluentbit` pod and press `l` to see the Fluent Bit logs
- Advanced commands for log readability to try:
  - Press `s` to toggle AutoScroll on/off
  - Press `w` to toggle Wrap on/off

> To exit K9s - `:q <enter>` or `ctl-c`

### Open Prometheus in Your Browser

```qsharp
- From the `PORTS` tab, open `Prometheus (30000)`
- From the query window, enter `resedge`
  - This will filter to your custom app metrics
- From the query window, enter `webv`
  - This will filter to the WebV metrics
```

### Open Grafana in Your Browser

- From the `PORTS` tab, open `Grafana (32000)`
  - Username: admin
  - Password: cse-labs
- Click on "General / Home" at the top of the screen and select "dotnet" to see Res-Edge Data Service health metrics
- Click on "General / Home" at the top of the screen and select "Application Dashboard" to see Res-Edge Data Service requests metrics
- You should see the Application Dashboard with both WebV and Res-Edge Data Service ("Application")
  - WebV will have 10 requests per second
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
