# Ring Deployment

- Resilient Edge ring deployment with Kustomize demo

## Quick Start

> Watch the internal only demo video [here](https://microsoft-my.sharepoint.com/:v:/p/bartr/EXFzHEAZvg1IhF-Sfs_HywwBB1CYOvBpTBPzy70a2FaUCw?e=zU3AYG)

- Make sure you are in this directory /workspaces/YOUR_REPO/labs/beta-labs/kustomize/README.md

## Create application overlay

Overlays on applications allow to deploy different application versions to different set of clusters.  You can use the  `kic overlay` command to perform this operation.

> Note: The implementation of `kic overlay` on this template uses the `imdb` application image as hardcoded image reference. In case you want to explore the template with your own applications, you need to manually update the image reference.

Execute the kic command as presented below where `1.0.1` is the version number and `imdb` is your app name:

```bash
kic overlay imdb 1.0.1
```

The `kic overlay` command creates a new `overlay/1.0.1` folder and a copies the `kustomization.yaml` file from `apps/imdb/kustomize/prod/base` to the new overlay folder in the `apps/imdb/kustomize/prod/` folder. You can update the `kustomization.yaml` file and set "beta" as the clusters metadata annotation. After the update, your file should look like the yaml sample below:

```yaml
# change clusters: none to clusters: beta
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

metadata:
  annotations:
    clusters: beta

resources:
  - deployment.yaml
  - service.yaml
  - ingress.yaml

images:
- name: ghcr.io/bartr/imdb
  newTag: 1.0.1
```

## Testing Local CICD

To generate and deploy the manifests for the clusters you can use `kic cicd` command.

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
