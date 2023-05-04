# Ring Deployment

- Res-Edge ring deployment with Kustomize lab
- Kustomize helps customizing config files without the need of templates
- Kustomize provides a number of handy methods like generators to make customization easier
- Kustomize uses overlays to introduce environment specific changes on an already existing standard config file without disturbing it
- Kustomize is like [make](https://www.gnu.org/software/make/), in that what it does is declared in a file
- Kustomize is like [sed](https://www.gnu.org/software/sed/), in that it emits edited text
- See the [Kustomize documentation](https://kubectl.docs.kubernetes.io/guides/introduction/kustomize/) for more information

## Prerequsite

- The Res-Edge Data Service needs to be deployed first for this lab
  - Go to [Deploy Res-Edge Data Service lab](../deploy-res-edge/README.md#inner-loop-with-res-edge) for steps on how to deploy the data service
- Start in this lab directory

  ```bash

  cd $REPO_BASE/labs/beta-labs/res-edge-labs/kustomize

  ```

- Verify that Res-Edge Data Service is up and running

  ```bash

  # check api version to verify Res-Edge Data Service is `Running`
  kic check resedge

  ```

## Create application overlay

- An overlay is a Kustomization that refers to the base and patches to transform the base when applied
- Overlays allow you to manage multiple configurations - such as dev, test, staging and prod - by transforming a shared base
- In this example, we will use an overlay on the IMDb application to define a different version to be deployed to a beta ring of clusters.
- In this lab, the ResEdge Data Service is set up with a default set of data including 19 clusters where the IMDb application is deployed to.
- To see which clusters should get updated when this occurs run the following command:

  ```bash

  # List all clusters in the group beta
  kic clusters list --group beta

  ```

- You can use the  `kic overlay` command to create the overlay structure

- Execute the kic command as presented below where `1.0.1` is the version number and `imdb` is your app name:

  ```bash

  kic overlay imdb 1.0.1

  ```

- The `kic overlay imdb 1.0.1` command creates a new `overlays/1.0.1` folder
- It will also create and open a new kustomization overlay file that references the base kustomization file with the new version defined
- Update the new `kustomization.yaml` file and set "beta" as the clusters metadata annotation
  - Codespaces saves the changes automatically
- After the update, your file should look like the yaml sample below:

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

- To generate and deploy the manifests for the clusters you can use `kic cicd` command

  > Note: kic is context aware so make sure you are running this in the folder where your `clusters` folder resides

  ```bash

  # `kic cicd` uses Res-Edge Data Service deployed to Codespaces
  kic cicd

  # Verify that clusters from the beta group were affected by `kic cicd` execution from the previous steps
  git diff

  ```

- Expected output

  ```diff
  diff --git a/labs/beta-labs/res-edge-labs/kustomize/clusters/central-la-nola-2301/imdb/imdb.yaml b/labs/beta-labs/res-edge-labs/kustomize/clusters/central-la-nola-2301/imdb/imdb.yaml
  index 76073ba..4db8893 100644
  --- a/labs/beta-labs/res-edge-labs/kustomize/clusters/central-la-nola-2301/imdb/imdb.yaml
  +++ b/labs/beta-labs/res-edge-labs/kustomize/clusters/central-la-nola-2301/imdb/imdb.yaml
  @@ -40,7 +40,7 @@ spec:
          - central
          - --zone
          - central-la
  -        image: ghcr.io/cse-labs/imdb:1.0.0
  +        image: ghcr.io/cse-labs/imdb:1.0.1
          imagePullPolicy: Always
          livenessProbe:
            failureThreshold: 10
  diff --git a/labs/beta-labs/res-edge-labs/kustomize/clusters/east-ga-atl-2301/imdb/imdb.yaml b/labs/beta-labs/res-edge-labs/kustomize/clusters/east-ga-atl-2301/imdb/imdb.yaml
  index 5547a84..405973e 100644
  --- a/labs/beta-labs/res-edge-labs/kustomize/clusters/east-ga-atl-2301/imdb/imdb.yaml
  +++ b/labs/beta-labs/res-edge-labs/kustomize/clusters/east-ga-atl-2301/imdb/imdb.yaml
  @@ -40,7 +40,7 @@ spec:
          - east
          - --zone
          - east-ga
  -        image: ghcr.io/cse-labs/imdb:1.0.0
  +        image: ghcr.io/cse-labs/imdb:1.0.1
          imagePullPolicy: Always
          livenessProbe:
            failureThreshold: 10
  diff --git a/labs/beta-labs/res-edge-labs/kustomize/clusters/west-ca-sd-2301/imdb/imdb.yaml b/labs/beta-labs/res-edge-labs/kustomize/clusters/west-ca-sd-2301/imdb/imdb.yaml
  index 882d7b0..290195a 100644
  --- a/labs/beta-labs/res-edge-labs/kustomize/clusters/west-ca-sd-2301/imdb/imdb.yaml
  +++ b/labs/beta-labs/res-edge-labs/kustomize/clusters/west-ca-sd-2301/imdb/imdb.yaml
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

## Reset clusters

- To reset the clusters back to the base kustomization, delete the overlay folder and run `kic cicd`

  ```bash

  # delete the overlay version folder
  rm -rf ./apps/imdb/kustomize/prod/overlays/1.0.1

  # run cicd to reset the imdb.yaml files in the clusters
  kic cicd

  # should be up to date
  git status

  ```
