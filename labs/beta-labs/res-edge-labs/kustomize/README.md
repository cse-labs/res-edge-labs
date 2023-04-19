# Ring Deployment

- Res-Edge ring deployment with Kustomize demo
- Kustomize helps customizing config files without the need of templates
- Kustomize provides a number of handy methods like generators to make customization easier
- Kustomize uses overlays to introduce environment specific changes on an already existing standard config file without disturbing it
- Kustomize is like [make](https://www.gnu.org/software/make/), in that what it does is declared in a file
- Kustomize is like [sed](https://www.gnu.org/software/sed/), in that it emits edited text
- See the [Kustomize documentation](https://kubectl.docs.kubernetes.io/guides/introduction/kustomize/) for more information

## Prerequsite

- The Res-Edge Data Service needs to be deployed first for this lab. Go to [Deploy Res-Edge lab](../deploy-res-edge/README.md#deploy-data-service) for steps on how to deploy the data.

```bash

#Verify Res-Edge is running
kic check resedge

```

## Create application overlay

- An overlay is just another kustomization, referring to the base, and referring to patches to apply to that base
- It lets you manage traditional variants of a configuration - like development, staging and production
- In this example, we will use an overlay on the IMDb application to define a different version to be deployed to a beta ring of clusters. To see which groups should get updated when this occurs run the following commands:

```bash

# To get the beta group id
kic groups list --search beta

# Insert the above group id in [betaId] to
kic groups show --id 2

```

- You can use the  `kic overlay` command to create the overlay structure

- Start in this lab directory

```bash

cd $REPO_BASE/labs/beta-labs/res-edge-labs/kustomize

```

- Execute the kic command as presented below where `1.0.1` is the version number and `imdb` is your app name:

```bash

kic overlay imdb 1.0.1

```

- The `kic overlay imdb 1.0.1` command creates a new `overlays/1.0.1` folder
- It will also create and open a new kustomization overlay file that references the base kustomization file with the new version defined
- Update the new `kustomization.yaml` file and set "beta" as the clusters metadata annotation
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

- To generate and deploy the manifests for the clusters you can use `kic cicd` command.

> Note: kic is context aware so make sure you are running this in the folder where your `clusters` folder resides.

```bash

# `kic cicd` uses Res-Edge Data Service deployed to localhost
kic cicd

# check the changes
git status

```

- Expected output

```text
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   clusters/central-la-nola-2301/imdb/imdb.yaml
        modified:   clusters/east-ga-atl-2301/imdb/imdb.yaml
        modified:   clusters/west-ca-sd-2301/imdb/imdb.yaml

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        apps/imdb/kustomize/prod/overlays/1.0.1/
```

## Reset clusters

- Delete labs/beta-labs/kustomize/apps/imdb/kustomize/prod/overlays/1.0.1
- Run `kic cicd`
- `git status` should now be up to date
