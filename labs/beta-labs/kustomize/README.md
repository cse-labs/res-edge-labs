# Ring Deployment

- Resilient Edge ring deployment with Kustomize demo

## Quick Start

> Watch the internal only demo video [here](https://microsoft-my.sharepoint.com/:v:/p/bartr/EXFzHEAZvg1IhF-Sfs_HywwBB1CYOvBpTBPzy70a2FaUCw?e=zU3AYG)

- Make sure you are in this directory

1. [Create a base definition for the app](#create-a-base-definition-for-the-app)
1. [Create application overlay](#create-application-overlay)
1. [CI/CD](#cicd)
1. [Reset clusters](#reset-clusters)
1. [Support](#support)
1. [Contributing](#contributing)
1. [Trademarks](#trademarks)

## Create a base definition for the app

Inside the folder `/apps/imdb/kustomize/prod/base` create the files `deployment.yaml`, `ingress.yaml`, `kustomization.yaml`, `service.yaml`, `namespace.yaml`.

## Create application overlay

Overlays on applications allow to deploy different application versions to different set of clusters.  You can use the  `kic overlay` command to perform this operation.

> Note: The implementation of `kic overlay` on this template uses the `imdb` application image as hardcoded image reference. In case you want to explore the template with your own applications, you need to manually update the image reference.

Execute the kic command as presented below where `1.0.1` is the version number:

```bash
kic overlay 1.0.1
```

The `kic overlay` command creates a new `overlay/1.0.1` folder and a new `kustomization.yaml` file in the `apps/imdb/kustomize/prod/` folder. You can update the `kustomization.yaml` file and set "beta" as the clusters metadata annotation. After the update, your file should look like the yaml sample below:

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
- name: ghcr.io/bart/imdb:latest
  newTag: 1.0.1
```

## CICD

To generate and deploy the manifests for the clusters you can use `kic cicd` and `kic deploy` commands.

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

- Delete labs/beta-labs/kustomize/apps/imdb/kustomize/prod/overlays/1.0.2
- Run `kic cicd`
- `git status` should now be up to date

## Support

This project uses GitHub Issues to track bugs and feature requests. Please search the existing issues before filing new issues to avoid duplicates.  For new issues, file your bug or feature request as a new issue.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.
