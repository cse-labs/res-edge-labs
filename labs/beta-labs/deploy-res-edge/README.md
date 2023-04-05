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
