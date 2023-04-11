# Ring Deployment

- Resilient Edge ring deployment with Kustomize demo
- Kustomize helps customizing config files without the need of templates
- See the [Kustomize documentation](https://kubectl.docs.kubernetes.io/guides/introduction/kustomize/) for more information

## Quick Start

> Watch the internal only demo video [here](https://microsoft-my.sharepoint.com/:v:/p/bartr/EXFzHEAZvg1IhF-Sfs_HywwBB1CYOvBpTBPzy70a2FaUCw?e=zU3AYG)

- Start in this lab directory

```bash
cd $REPO_BASE/labs/beta-labs/kustomize
```

## Create application overlay

Overlays on applications allow to deploy different application versions to different set of clusters.

You can use the  `kic overlay` command to perform this operation.

Execute the kic command as presented below where `1.0.1` is the version number and `imdb` is your app name:

```bash

kic overlay imdb 1.0.1

```

- The `kic overlay imdb 1.0.1` command creates a new `overlays/1.0.1` folder
- It will also create and open a new kustomization overlay file that references the base kustomization file with the new version defined
- Update the new `kustomization.yaml` file and set "beta" as the clusters metadata annotation. After the update, your file should look like the yaml sample below:

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
- name: ghcr.io/bartr/imdb
  newTag: 1.0.1
```

## Testing Local CICD

To generate and deploy the manifests for the clusters you can use `kic cicd` command.

### Verify ResEdge Data Service

- `kic cicd` uses ResEdge data service deployed to localhost
- If you have not already done so, deploy ResEdge from the [deploy ResEdge lab](../deploy-res-edge/README.md#deploy-data-service)

```bash

# Verify ResEdge is running
kic check resedge

```

### Generate manifests

> Note: kic is context aware so make sure you are running this in the folder where your `clusters` folder resides.

```bash

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
