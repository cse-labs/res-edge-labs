# Deploy Flux to Store Cluster

- Install [chocolatey](https://chocolatey.org/install)
- Install Flux
  - `choco install flux`

```bash

# clone this repo (substitute $PAT)
git clone https://$PAT@github.com/cse-labs/res-edge-labs gitopsrepo
cd gitopsrepo
git pull

# checkout this branch
git checkout labs --
git pull

# change to central-la-nola-2301 directory
cd clusters/central-la-nola-2301/flux-system

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

## Deploy Workloads

- Go to <https://res-edge.com>
- Login with your GitHub name and Res-Edge-Admin
- Open Namespaces
- Open IMDb
- Change the Expression to `/g/beta` or `/c/2`
  - To undeploy, change Expression to blank
- Save
- Click on Logs to make sure Automation has completed
- Wait for Flux to sync the cluster (or use the reconcile command from above)
- Check the pods for the desired result

## Creating a new cluster

- Open <https://res-edge.com>
- Login as above
- Click on Clusters
- Click on New Cluster
- Fill out the information
- Note the following Metadata fields are required and are case sensitive
  - region: [central, east, west]
  - state: [valid lower case state abbreviation]
  - city: [valid lower case city abbreviation]
  - type: store
  - ring: [beta, pilot, or prod]
- Click Save
- Click on Logs - make sure automation was successful - you may have to refresh
- Use the above steps from the /clusters/yourName/flux-system directory

## Uninstall Flux

- You can uninstall Flux and repeat the process
  - `flux uninstall -s`
- Note this will not delete the deployed apps
- Run this after flux is uninstalled to delete the apps - you can ignore any namespace not found errors
  - `kubectl delete ns cert-manager heartbeat ingress-nginx imdb dogs-cats tabs-spaces`
