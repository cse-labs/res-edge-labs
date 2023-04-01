# Ring Deployment

- Resilient Edge ring deployment with Kustomize demo

## Quick Start

> Watch the internal only demo video [here](https://microsoft-my.sharepoint.com/:v:/p/bartr/EXFzHEAZvg1IhF-Sfs_HywwBB1CYOvBpTBPzy70a2FaUCw?e=zU3AYG)

- Make sure you are in this directory

```bash

kic overlay 1.0.1

# change clusters: none to clusters: beta

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
