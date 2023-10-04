# Ring Deployment with Kustomize

Application teams often want to deploy new versions of their app(s) to a growing subset of clusters. Res-Edge uses [Kustomize](https://kubectl.docs.kubernetes.io/guides/introduction/kustomize/), `Groups`, `Namespaces`, and `Applications` to provide `ring deployments`.

The `Groups`, `Namespaces`, and `Applications` are objects in the Res-Edge Data Service. Res-Edge provides `GitOps Automation` to merge the objects via `GitOps` (Flux). Kustomize further transforms the manifests used by GitOps for deployment.

## Kustomize Overview

- Kustomize helps customizing config files without the need of templates
- Kustomize provides a number of handy methods like generators to make customization easier
- Kustomize uses overlays to introduce environment specific changes on an already existing standard config file without disturbing it
- Kustomize is like [make](https://www.gnu.org/software/make/), in that what it does is declared in a file
- Kustomize is like [sed](https://www.gnu.org/software/sed/), in that it emits edited text
- See the [Kustomize documentation](https://kubectl.docs.kubernetes.io/guides/introduction/kustomize/) for more information

## Prerequisites

- The Res-Edge Data Service needs to be deployed for this lab
  - Go to [Deploy Res-Edge Data Service lab](../deploy-res-edge.md#inner-loop-with-res-edge) to deploy the data service to the cluster
- Groups need to be assigned to a Namespace for this lab
  - Go to [Assign Group to Namespace lab](../labs/assign-group-to-namespace.md) to assign stores Group to imdb Namespace

## Verify that the data service is running

  ```bash

  # check api version to verify Res-Edge Data Service is `Running`
  kic check resedge

  ```

## Setup a clean environment

```bash

# start in the repo base directory
cd "$KIC_BASE"


# Warning: this will delete any existing data changes and they are not recoverable
ds reload --force

# redeploy IMDb
# will return 204 No Content
ds update namespace --id 3 --expression /g/stores

# run ci-cd locally
ds cicd

# deploy the clusters directory changes
ds deploy

```

## Create an application overlay

- An overlay is a Kustomization that refers to the base and patches to transform the base when applied
- Overlays allow you to manage multiple configurations - such as dev, test, staging and prod - by transforming a shared base
- In this lab, we will use an overlay on the IMDb application to define a different version to be deployed to the beta `Group`
- Use the `ds CLI` to see the definition of the beta `Group`

  ```bash

  # List all clusters in the group beta
  ds list clusters --group-id 1

  ```

- Use the `ds overlay` command to create the overlay structure
  - `imdb` is the application name
  - `1.0.1` is the new version

    ```bash

    ds overlay --app-name imdb --version 1.0.1

    ```

- The `ds overlay imdb 1.0.1` command creates a new `overlays/1.0.1` folder
- It will also create and open a new kustomization overlay file that references the base kustomization file with the new version defined
- Update the new `kustomization.yaml` file and set "beta" as the clusters metadata annotation
  - Codespaces saves the changes automatically
- After updating, your file should look like the yaml sample below:

  ```yaml
  # change clusters: none to clusters: beta
  apiVersion: kustomize.config.k8s.io/v1beta1
  kind: Kustomization
  metadata:
    annotations:
      version: 1.0.1
      clusters: beta
  resources:
  - ../../base

  images:
  - name: ghcr.io/cse-labs/imdb
    newTag: 1.0.1
  ```

## CICD Dry Run

- Use the `ds cicd` command to generate the new manifests

  ```bash

  # `ds cicd` uses Res-Edge Data Service deployed to Codespaces
  ds cicd

  # Verify that the clusters from the beta `Group` were updated by `ds cicd`
  git diff

  ```

- Expected output

  ```diff
  diff --git a/labs/res-edge-labs/kustomize/clusters/central-la-nola-2301/imdb/imdb.yaml b/labs/res-edge-labs/kustomize/clusters/central-la-nola-2301/imdb/imdb.yaml
  index 76073ba..4db8893 100644
  --- a/labs/res-edge-labs/kustomize/clusters/central-la-nola-2301/imdb/imdb.yaml
  +++ b/labs/res-edge-labs/kustomize/clusters/central-la-nola-2301/imdb/imdb.yaml
  @@ -40,7 +40,7 @@ spec:
          - central
          - --zone
          - central-la
  -        image: ghcr.io/cse-labs/imdb:1.0.0
  +        image: ghcr.io/cse-labs/imdb:1.0.1
          imagePullPolicy: Always
          livenessProbe:
            failureThreshold: 10
  diff --git a/labs/res-edge-labs/kustomize/clusters/east-ga-atl-2301/imdb/imdb.yaml b/labs/res-edge-labs/kustomize/clusters/east-ga-atl-2301/imdb/imdb.yaml
  index 5547a84..405973e 100644
  --- a/labs/res-edge-labs/kustomize/clusters/east-ga-atl-2301/imdb/imdb.yaml
  +++ b/labs/res-edge-labs/kustomize/clusters/east-ga-atl-2301/imdb/imdb.yaml
  @@ -40,7 +40,7 @@ spec:
          - east
          - --zone
          - east-ga
  -        image: ghcr.io/cse-labs/imdb:1.0.0
  +        image: ghcr.io/cse-labs/imdb:1.0.1
          imagePullPolicy: Always
          livenessProbe:
            failureThreshold: 10
  diff --git a/labs/res-edge-labs/kustomize/clusters/west-ca-sd-2301/imdb/imdb.yaml b/labs/res-edge-labs/kustomize/clusters/west-ca-sd-2301/imdb/imdb.yaml
  index 882d7b0..290195a 100644
  --- a/labs/res-edge-labs/kustomize/clusters/west-ca-sd-2301/imdb/imdb.yaml
  +++ b/labs/res-edge-labs/kustomize/clusters/west-ca-sd-2301/imdb/imdb.yaml
  @@ -40,7 +40,7 @@ spec:
          - west
          - --zone
          - west-ca
  -        image: ghcr.io/cse-labs/imdb:1.0.0
  +        image: ghcr.io/cse-labs/imdb:1.0.1
          imagePullPolicy: Always
          livenessProbe:
            failureThreshold: 10
  ```

## Reset manifests

- To reset the manifests to the base kustomization, delete the overlay folder and run `ds cicd` again

  ```bash

  # delete the overlay version folder
  rm -rf ./apps/imdb/kustomize/prod/overlays/1.0.1

  # run cicd to reset the imdb.yaml files in the clusters
  ds cicd

  # should be up to date
  git status

  ```
