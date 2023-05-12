# Debugging the Application Dashboard

In Grafana, it is important to understand why we are seeing `10.2` requests per second under the Application Dashboard rather than the `10` requests per second we see under WebV.

Kubernetes (K8s) generates a liveness probe to /healthz every 1 min and Promethus "scrapes" every 5 seconds, so the app "responds" with an extra .2 RPS.

In this lab we will learn where to look to debug when we see an irregular number in the dashboard.

## Prerequisites

- The Res-Edge Data Service needs to be deployed for this lab
  - Go to [Deploy Res-Edge Data Service lab](./deploy-res-edge/README.md#inner-loop-with-res-edge) to deploy the data service to the cluster

## Problem

The Grafana Application Dashboard displays `10.1` requests per second instead of the expected `10.2` requests per second.

## Resetting Environment to reproduce error

The api needs to be installed with the beta version to reproduce the error.

- Create a new branch

  ```bash

  git checkout -b debug-lab

  ```

- Delete the webv and api deployments

  ```bash

  cd ./deploy-res-edge/api

  # `kdelf` is an alias for `kubectl delete -f`
  kdelf deployment.yaml

  cd ../webv

  kdelf deployment.yaml

  # should no longer see webv or api pods
  kic pods

  ```

## Redeploy app with issue

- edit `api/deployment.yaml` to image `ghcr.io/cse-labs/res-edge:beta`

  ```yaml

  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: api
    namespace: api
    labels:
      app: api
  spec:
    replicas: 1
    strategy:
      type: Recreate
    selector:
      matchLabels:
        app: api
    template:
      metadata:
        labels:
          app: api
      spec:
        terminationGracePeriodSeconds: 30
        containers:
        - name: app
          image: ghcr.io/cse-labs/res-edge:beta # update to image with issue
          imagePullPolicy: Always
          ports:
            - name: http
              containerPort: 8080
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /healthz
              port: http
            initialDelaySeconds: 5
            failureThreshold: 10
            periodSeconds: 60
          startupProbe:
            httpGet:
              path: /readyz
              port: http
            initialDelaySeconds: 5
            failureThreshold: 60
            periodSeconds: 2
          resources:
            limits:
              memory: 1Gi
              cpu: 1000m
            requests:
              memory: 512Mi
              cpu: 500m

  ```

- Deploy api again

  ```bash

  # deploy the Res-Edge Data Service
  kak api

  # "watch" for the api pod to get to 1/1 Running
  # ctl-c to exit
  kic pods --watch

  # verify Res-Edge Data Service is `Running`
  kic check resedge

  ```

## Open Application Dashboard in Grafana

- From the `PORTS` tab, open `Grafana (32000)`
  - Username: admin
  - Password: cse-labs
- Click on "General / Home" at the top of the screen and select "Application Dashboard" to see a custom application dashboard
- You should see the Application Dashboard with both WebV and Res-Edge Data Service ("Application")
  - WebV will have `0` requests per second because we stopped the WebV app
  - Application will have `10.1` requests per second
  > Remember that we are expecting to see `10.2` requests per second
- Keep "Application Dashboard" open in a browser tab to monitor Res-Edge Data Service requests metrics for the next section

## Open k9s for Logs

- Start `k9s` from the Codespace terminal
- Press `0` to show all `namespaces`
- Select `api` pod and press `l` to review the Res-Edge Data Service logs
  - Let the logs run for about 2 mins
- Press `s` to turn off `autoscroll`
- Press `w` to turn on `wrap` for better visibility


## Diving deeper into the Logs

- **Api is up and running**

  We can see in the [api/deployment.yaml](./deploy-res-edge/api/deployment.yaml) that we have a startup probe set to call `/readyz` to check when the api is up and running:

  ```yaml

  startupProbe:
    httpGet:
      path: /readyz
      port: http
    initialDelaySeconds: 5
    failureThreshold: 60
    periodSeconds: 2

  ```

  - In k9s, this log will appear as follows:

    ```json

    {"date":"2023-05-12T22:21:10.9878166Z","level":"Information","ElapsedMilliseconds":93.8659,"StatusCode":200,"ContentType":"text/plain","ContentLength":null,"Protocol":"HTTP/1.1","Method":"GET","Scheme":"http","Host":"10.42.0.18:8080","environment":"Development","Path":"/readyz","QueryString":"","zone":"dev","EventId":{"Id":2},"SourceContext":"Microsoft.AspNetCore.Hosting.Diagnostics","region":"dev","RequestPath":"/readyz","version":"0.9.0-0509-1854","node":""}

    ```

- **K8s Healthcheck every minute**

  Another setting we have in the [api/deployment.yaml](./deploy-res-edge/api/deployment.yaml) is set a `livenessProbe` to call `/healthz` after a specified interval.
    - `periodSeconds` tells the api to run a GET call to `/healthz` every `60` seconds

  ```yaml

  livenessProbe:
    httpGet:
      path: /healthz
      port: http
    initialDelaySeconds: 5
    failureThreshold: 10
    periodSeconds: 60

  ```

  - In k9s, these logs will appear as follows:

    ```json

    {"date":"2023-05-12T22:05:45.8828087Z","level":"Information","ElapsedMilliseconds":8.0708,"StatusCode":200,"ContentType":"text/plain","ContentLength":null,"Protocol":"HTTP/1.1","Method":"GET","Scheme":"http","Host":"10.42.0.16:8080","environment":"Development","Path":"/healthz","QueryString":"","zone":"dev","EventId":{"Id":2},"SourceContext":"Microsoft.AspNetCore.Hosting.Diagnostics","region":"dev","RequestPath":"/healthz","version":"0.9.0-0509-1854","node":""}

    {"date":"2023-05-12T22:06:45.8839286Z","level":"Information","ElapsedMilliseconds":8.4692,"StatusCode":200,"ContentType":"text/plain","ContentLength":null,"Protocol":"HTTP/1.1","Method":"GET","Scheme":"http","Host":"10.42.0.16:8080","environment":"Development","Path":"/healthz","QueryString":"","zone":"dev","EventId":{"Id":2},"SourceContext":"Microsoft.AspNetCore.Hosting.Diagnostics","region":"dev","RequestPath":"/healthz","version":"0.9.0-0509-1854","node":""}

    ```

- **Prometheus Scrape and Export**

  We know by looking at the [prometheus/2-config-map.yaml](./deploy-res-edge/monitoring/prometheus/2-config-map.yaml) file under the `global` section that Prometheus scrapes /metrics for logs and exports them to Grafana during a specified interval.
    - `scrap_interval` tells Promethus to scrape `/metrics` every `5` seconds
    - `evaluation_interval` tells Promethus to export the metrics to Grafana every `5` seconds

  ```yaml

    prometheus.yml: |-
      global:
        scrape_interval: 5s
        evaluation_interval: 5s

  ```

  - In k9s, these logs will appear as follows:

    ```json

    {"date":"2023-05-12T22:06:39.7438317Z","level":"Information","ElapsedMilliseconds":4.3562,"StatusCode":200,"ContentType":"application/openmetrics-text; version=1.0.0; charset=utf-8","ContentLength":null,"Protocol":"HTTP/1.1","Method":"GET","Scheme":"http","Host":"api.api.svc.cluster.local:8080","environment":"Development","Path":"/metrics","QueryString":"","zone":"dev","EventId":{"Id":2},"SourceContext":"Microsoft.AspNetCore.Hosting.Diagnostics","region":"dev","RequestPath":"/metrics","version":"0.9.0-0509-1854","node":""}

    {"date":"2023-05-12T22:06:44.7434026Z","level":"Information","ElapsedMilliseconds":3.8298,"StatusCode":200,"ContentType":"application/openmetrics-text; version=1.0.0; charset=utf-8","ContentLength":null,"Protocol":"HTTP/1.1","Method":"GET","Scheme":"http","Host":"api.api.svc.cluster.local:8080","environment":"Development","Path":"/metrics","QueryString":"","zone":"dev","EventId":{"Id":2},"SourceContext":"Microsoft.AspNetCore.Hosting.Diagnostics","region":"dev","RequestPath":"/metrics","version":"0.9.0-0509-1854","node":""}

    ```

- **WebV Logs**

  When we have WebV running, we will see 10 GET requests per second on top of our other api logs. These will appear as follows:

  ```json

  {"date":"2023-05-12T22:58:51.6861887Z","level":"Information","ElapsedMilliseconds":9.5128,"StatusCode":200,"ContentType":"application/json; odata.metadata=minimal; odata.streaming=true; charset=utf-8","ContentLength":null,"Protocol":"HTTP/1.1","Method":"GET","Scheme":"http","Host":"api.api.svc.cluster.local:8080","environment":"Development","Path":"/api/v1/clusters/17","QueryString":"?$select=id,name,description,environment,gitOpsRepo,gitOpsBranch,tags,metadata,capacity,namespaces&$expand=namespaces($expand=applications($select=id,name,description,tags,metadata,environment,namespaceId,pat,path,businessUnit,owner,capacity);$select=id,name,description,tags,metadata,environment,businessUnit,capacity)","zone":"dev","EventId":{"Id":2},"SourceContext":"Microsoft.AspNetCore.Hosting.Diagnostics","region":"dev","RequestPath":"/api/v1/clusters/17","version":"0.9.0-0509-1854","node":""}

  ```
