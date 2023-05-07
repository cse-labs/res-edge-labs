# Inner-loop with Res-Edge

- Res-Edge helps build a powerful system for automated deployment, update, management, and observability for thousands of Kubernetes (K8s) clusters
- Res-Edge Data Service is a component of Res-Edge that enhances the experience of managing the complexity of applications deployments to K8s environments at scale by providing a centralized inventory system which supports complex hierarchies
- This lab will go over steps to run Res-Edge Data Service with Observability in Codespaces

## Prerequisites

- To get more familiarity with Codespaces and other tools used in this lab, please complete the inner-loop lab [here](../../inner-loop.md#inner-loop)

## Create a new cluster

> The k3d cluster will run `in` the Codespace - no need for an external cluster

- Start in this lab directory

  ```bash

  cd $REPO_BASE/labs/res-edge-labs/deploy-res-edge

  ```

- Use the `kic CLI` to create and verify a new k3d cluster

  ```bash

  # delete and create a new cluster
  # ignore no-cluster error message
  kic cluster create

  # check the K8s pods
  kic pods

  # The `--watch` flag will update the last line in the terminal output
  kic pods --watch

  # "watch" for the last line to read '1/1 Running' after the '0/1 ContainerCreating'
  # Press `ctrl-c` to exit

  ```

## Deploy SQL Server

- In this section, we will deploy SQL Server to the local K8s cluster
  - Res-Edge Data Service requires a SQL Server database
  - This database serves as storage for Applications, Clusters, Groups, Namespaces, and Policies
- Once the container starts, it will populate the database with sample data
  - 19 Applications
  - 19 Clusters
  - 19 Groups
  - 19 Namespaces
  - 3 Policies
- Run `alias` to view all aliases defined in the Codespace
  - `k` is an alias for `kubectl`
  - `kaf` is an alias for `kubectl apply -f`, where `-f` is the manifest file to apply
  - `kak` is an alias for `kubectl apply -k`, where `-k` is the path that contains kustomization.yaml

    ```bash

    # create the namespace
    kaf ns.yaml

    # deploy SQL Server with sample data
    kak mssql

    # "watch" for the mssql pod to get to 1/1 Running
    # ctl-c to exit
    kic pods --watch

    # view K8s logs
    kic logs mssql

    # "follow" the mssql logs until the sample data loads with "# rows affected"
    # ctl-c to exit
    kic logs mssql --follow

    # Verify mssql is running and the sample data is loaded
    kic check mssql

    ```

## Deploy Res-Edge Data Service

- The data service is a REST/OData API to perform CRUD operations on the Res-Edge objects
- The data service uses the SQL Server deployed previously for storage

  ```bash

  # deploy the Res-Edge Data Service
  kak api

  # "watch" for the api pod to get to 1/1 Running
  # ctl-c to exit
  kic pods --watch

  # verify Res-Edge Data Service is `Running`
  kic check resedge

  ```

## Test Res-Edge Data Service

- To validate the Res-Edge Data Service is working properly, we will use `kic test` to generate 200, 300, 400, and 404 responses
  - `kic test` uses `WebValidate` (WebV) which is installed in the Codespace
    - For more information on WebV, see [here](https://github.com/microsoft/webvalidate)
  - "Errors 0" in the summary line indicates all tests passed

    ```bash

    kic test all

    ```

## Query Res-Edge Data Service

> To dive deeper into these commands and learn more about filtering results, go to [Sample Data Service Queries](./sample-queries.md)

- Run `kic [entity-type] list` to query the Res-Edge Data Service and return all objects in this data service

  ```bash

  kic applications list

  kic clusters list

  kic groups list

  kic namespaces list

  kic policies list

  ```

- Run `kic [entity-type] list --search [entity-name]` to return a list of objects that have an exact match for the search term on the name, metadata, or tags fields

  ```bash

  kic applications list --search imdb

  kic clusters list --search central-la-nola-2301

  kic groups list --search beta

  kic namespaces list --search imdb

  kic policies list --search dns-ingress

  ```

- Run `kic [entity-type] show --id [entity-id]` to return a specific entity's information

  ```bash

  kic applications show --id 2

  kic clusters show --id 2

  kic groups show --id 2

  kic namespaces show --id 2

  kic policies show --id 2

  ```

## Observability

- The CNCF obervability stack is deployed in the cluster with no external dependencies
- Fluent Bit, Prometheus, and Grafana will be deployed to the K8s cluster in the next step
  - K9s is deployed to the Codespace by default

### Fluent Bit

- Fluent Bit is configured to forward logs to stdout for debugging
- Fluent Bit can be configured to forward to different services including [Loki](https://grafana.com/oss/loki/) or [Azure Log Analytics](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-overview)
- See the [Fluent Bit documentation](https://docs.fluentbit.io/manual/) for more information on Fluent Bit

### Prometheus

- Prometheus is a de-facto standard for K8s metrics
- We have defined custom metrics for Prometheus
- See the [Prometheus documentation](https://prometheus.io/docs/introduction/overview/) for more information

### Grafana

- Grafana is a de-facto standard for K8s dashboards
- We have defined two custom Grafana dashboards using Prometheus metrics
- Explore the [Grafana documentation](https://grafana.com/docs/) to learn about more data sources, visualizations, and capabilities

### K9s

- K9s is deployed in the Codespace
- K9s is a commonly used tool that reduces the complexity of `kubectl`
  - Continually watches K8s for changes and has commands to interact with resources
  - Tracks cluster metrics and displays logs of deployed applications
- See the [K9s documentation](https://k9scli.io/topics/commands/) for more information on K9s

## Deploy Observability

```bash

# deploy observability
kak monitoring

# "watch" for the prometheus, fluentbit, and grafana pods to get to 1/1 Running
# ctl-c to exit
kic pods --watch

# check to verify prometheus, fluentbit, and grafana are running
kic check prometheus
kic check fluentbit
kic check grafana

```

## Deploy WebV

- This step will create a WebV pod in the cluster to generate continuous traffic to the data service
  - Previously, we used WebV from the Codespace
- Prometheus scrapes the metrics every 5 seconds
- The Grafana dashboards use the WebV metrics for observability

  ```bash

  # deploy webv
  kak webv

  # "watch" for the webv pod to get to 1/1 Running
  # ctl-c to exit
  kic pods --watch

  # check to verify webv is running
  kic check webv

  # check the logs, you should see requests logs
  # alternatively, you can use k9s
  kic logs webv
  kic logs resedge

  ```

### Observability in Action

#### View Logs in K9s

```bash

# Start `k9s` from the Codespace terminal
k9s

```

- Press `0` to show all `namespaces`
- Select `api` pod and press `l` to review the Res-Edge Data Service logs
  - You should see the following successful (statusCode 200) logs:
    - K8s healthcheck every minute
    - Prometheus scrape to /metrics logs every 5 seconds
    - 10 GET requests from WebV every second
- Press `esc` to return to Pod View
- Select `webv` pod and press `l` to review the WebV logs
  - You should see 10 successful 200 requests per second
- Press `esc` to return to Pod View
- Select `fluentbit` pod and press `l` to see the Fluent Bit logs
  - Notice that fluentbit logs are batched every 5-10 seconds

#### Advanced commands for log readability

- Press `s` to toggle AutoScroll on/off
- Press `w` to toggle Wrap on/off

> To exit K9s - `:q <enter>` or `ctl-c`

### Open Prometheus in the browser

- From the `PORTS` tab, open `Prometheus (30000)`
- From the query window, enter `resedge`
  - This will filter to the custom app metrics
- From the query window, enter `webv`
  - This will filter to the WebV metrics

### Open Grafana in the browser

- From the `PORTS` tab, open `Grafana (32000)`
  - Username: admin
  - Password: cse-labs
- Click on "General / Home" at the top of the screen and select "dotnet" to see a standard dotnet dashboard
- Click on "General / Home" at the top of the screen and select "Application Dashboard" to see a custom application dashboard
- You should see the Application Dashboard with both WebV and Res-Edge Data Service ("Application")
  - WebV will have 10 requests per second
  - Application will have 10.2 requests per second
    - K8s calls /healthz every minute
    - Prometheus calls /metrics every 5 seconds
    - WebV generates 10 requests per second
- Keep "Application Dashboard" open in a browser tab to monitor Res-Edge Data Service requests metrics for the next section
  - The version number of Res-Edge Data Service and WebV will appear below "Application" and "WebV" accordingly

### Generate more requests for the dashboards

- Run a 30 second load test in the background to generate 60 req/sec

  ```bash

  kic test load &

  ```

- Generate 200, 300, 400, and 404 responses
  - Can be run concurrently with the load test

  ```bash

  kic test all

  ```
