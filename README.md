# Deploy Flux to Store Cluster

This lab walks user through the process of deploying Flux to a non-arc enabled cluster.  

## Prerequisites

- This lab can be executed from any system that can access <https://github.com/cse-labs/res-edge-labs>, and <https://res-edge.com>
- his lab requires kubectl [Installation Instructions](https://kubernetes.io/docs/tasks/tools/#kubectl)
- This lab requires the Flux CLI - [Installation Instructions](https://fluxcd.io/flux/installation/#install-the-flux-cli)
- This lab requires an existing k8s cluster with kubectl set to work on that cluster. Setting up such cluster is out of scope for this lab.

## Steps

1. Create a new cluster in Res-Edge

    - Open <https://res-edge.com>
    - Login
    - Click on Clusters [direct link](https://res-edge.com/clusters)
    - Click on New Cluster
    - Fill out the information
    - Note the following Metadata fields are required and are case sensitive
      - region: [central, east, west]
      - state: [valid lower case state abbreviation]
      - city: [valid lower case city abbreviation]
      - type: store
      - ring: [beta, pilot, or prod]
    - Click Save
    - Add cluster to the stores group by navigating to Groups and clicking the edit icon on the /stores/ group [direct link](https://res-edge.com/group?id=4)
    - Click on Logs - make sure automation was successful - you may have to refresh

2. Checkout gitops repo

    ```bash
    # clone this repo (substitute $PAT)
    git clone https://github.com/cse-labs/res-edge-labs gitopsrepo
    cd gitopsrepo
    git pull

    # checkout this branch
    git checkout labs --
    git pull

    # change to directory for your newly created cluster
    cd clusters/your-cluster-name/flux-system
    ```

3. The following should be executed against the k8s cluster that you are working with

    ```bash
    # create the namespace
    kubectl apply -f namespace.yaml

    # create the Flux secret (substitute $PAT)
    # the PAT must have permissions to the repo
    flux create secret git flux-system -n flux-system --url https://github.com/cse-labs/res-edge-labs -u gitops -p $PAT

    # deploy the Flux components
    kubectl apply -f components.yaml

    # create the Flux Source
    kubectl apply -f source.yaml

    # this single kustomization will manage all of the kustomizations generated by Res-Edge-Automation
    kubectl apply -f flux-kustomization.yaml

    # force flux to reconcile
    flux reconcile source git gitops

    # check pods for cert-manager, heartbeat, and ngninx-ingress
    kubectl get pods -A
    ```

4. Deploy Workloads
    - Go to <https://res-edge.com>
    - Login
    - Open Namespaces
    - Open IMDb
    - Change the Expression to `/g/stores`
      - To undeploy, change Expression to blank
    - Save
    - Click on Logs to make sure Automation has completed
    - Wait for Flux to sync the cluster (or use the reconcile command from above)
    - Check the pods for the desired result

5. Uninstall Flux

    - You can uninstall Flux and repeat the process
      - `flux uninstall -s`
    - Note this will not delete the deployed apps
    - Run this after flux is uninstalled to delete the apps - you can ignore any namespace not found errors
      - `kubectl delete ns cert-manager heartbeat ingress-nginx imdb dogs-cats tabs-spaces`
