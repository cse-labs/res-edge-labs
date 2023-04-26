# Kubernetes in Codespaces

## Introduction

Kubernetes is hard. Getting started and set up for the first time can take weeks to get right. Managing deployments on a fleet of Kubernetes clusters on the edge brings even more challenges.

Kubernetes in Codespaces (KiC) is a `game-changer` for the end-to-end Kubernetes app development cycle from a local cluster to deployments on the edge. It reduces the initial friction and empowers the developer to get started and deployed to a dev/test environment within *minutes*. The pre-configured Codespaces environment includes a `Kubernetes` cluster and custom command line interfaces (`kic` and `flt`) that help streamline the initial learning curve to Kubernetes development commands.

This repo walks through the rich end-to-end developer experience via a series of labs. The labs start by walking you through creating, building, testing, and deploying an application on a local cluster running inside Codespaces ([inner-loop](./README.md#inner-loop)) with a complete [CNCF observability](https://landscape.cncf.io/card-mode?category=observability-and-analysis&project=graduated,incubating,sandbox) stack ([Grafana](https://grafana.com/), [Prometheus](https://prometheus.io/docs/introduction/overview/), and [Fluent Bit](https://fluentbit.io/)). Then, the labs move on to the next step of deploying the application to a test cluster in the Cloud ([outer-loop](./README.md#outer-loop)). There are also several [advanced labs](./README.md#advanced-labs) that cover centralized monitoring, canary deployments, and targeting different devices.

## Prerequisites

- GitHub Codespaces access
- An Azure subscription with owner access
  - A [free Azure subscription](https://azure.microsoft.com/en-in/free/) will work for exploration
  - Some advanced scenarios also require AAD permissions

## Notes

- The base Codespaces images recently updated to dotnet core 7
- Both dotnet core 6 and 7 are installed in the Codespaces image as we migrate to dotnet 7

## GitHub Codespaces

> Codespaces allows you to develop in a secure, configurable, and dedicated development environment in the cloud that works how and where you want it to

- [GitHub Codespaces Overview](https://docs.github.com/en/codespaces)
  - GitHub Codespaces is available to all GitHub users and organizations
  - For more information, see ["GitHub's products"](https://docs.github.com/en/get-started/learning-about-github/githubs-products)

We use GitHub Codespaces for our `inner-loop` and `outer-loop` Developer Experiences. While other DevX are available, currently, we only support GitHub Codespaces.

> Best Practice: as you begin projects, ensure that you have Codespaces and Azure subscriptions with proper permissions

## inner-loop

- `inner-loop` refers to the tasks that developers do every day as part of their development process
  - Generally, `inner-loop` happens on the individual developer workstation
    - For KiC, the inner-loop and developer workstation is Codespaces
    - When a developer creates a Codespace, that is their "personal development workstation in the cloud"
- As part of KiC, we have automated the creation of the developer workstation using a repeatable, consistent, Infrastructure as Code approach
  - We have an advanced workshop planned for customizing the Codespaces experience for your project
- With the power of Codespaces, a developer can create a consistent workstation with a few clicks in less than a minute

## outer-loop

- `outer-loop` refers to the tasks that developers and DevOps do as they move from dev to test to pre-prod to production
  - Generally `outer-loop` happens on shared compute outside of the developer workstation
  - For KiC, outer-loop uses a combination of Codespaces and `dev/test clusters` in Azure
- As part of KiC, we have automated the creation of dev/test clusters using a repeatable, consistent, Infrastructure as Code approach

## Create a new Repo

- Click `Use this template`
  - Select `Create a new repository`

## Create a Codespace

- Create a Codespace from the repo you created. You can use the same Codespace for any of the labs.

> Note: make sure you create a codespace from the created repo, not the template repo.

- Click the `<> Code` button
  - Make sure the Codespaces tab is active
- Click `Create Codespace on main`
- After about 5 minutes, you will have a GitHub Codespace running with a complete Kubernetes Developer Experience!

## Environment variables

Many of these tutorials make use of environment variables, using the export functionality. If you wish, you can also edit the Z shell preferences file to persist exported environment variables across terminal sessions. Just add the same "export FOO=BAR" lines to your .zshrc file.

```bash

code ~/.zshrc

```

## inner-loop Labs

- [Lab 1](./labs/inner-loop.md#inner-loop): Create, build, deploy, and test a new dotnet application and observability stack on your local cluster
- [Lab 2](./labs/inner-loop-flux.md#create-a-new-cluster): Configure flux to automate the deployment process from Lab 1

## outer-loop Labs

- [Lab 1](./labs/outer-loop.md#outer-loop): Create a dev/test cluster and manage application deployments on the cluster
- [Lab 2](./labs/outer-loop-multi-cluster.md#outer-loop-multi-cluster): Manage application deployments on a fleet of multiple clusters
- [Lab 3](./labs/outer-loop-ring-deployment.md#outer-loop-with-ring-based-deployment): Configure ring based deployments

- [Lab 4](./labs/azure-codespaces-setup.md#azure-subscription-and-codespaces-setup): Set up Azure subscription and Codespaces for advanced configuration
  - This is a prerequisite for the Advanced Labs

## Advanced Labs

- [Arc enabled GitOps Lab](./labs/outer-loop-arc-gitops.md#outer-loop-with-arc-enabled-gitops): Deploy to dev cluster running on an Azure VM with Arc enabled GitOps
- [Canary Deployment Lab](./labs/advanced-labs/canary/README.md#automated-canary-deployment-using-flagger): Use Flagger to experiment with canary deployments
- [Centralized Observability Lab](./labs/advanced-labs/monitoring/README.md#centralized-monitoring): Deploy a centralized observability system with Fluent Bit, Prometheus, and Grafana to monitor fleet application deployments
- [outer-loop with AKS-IoT Lab](./labs/advanced-labs/aks-iot/README.md#outer-loop-to-aks-iot): Deploy to an AKS-IoT cluster running on an Azure VM with Arc enabled GitOps
- [outer-loop with AKS Lab](./labs/outer-loop-aks-azure.md#outer-loop-to-aks-on-azure): Deploy to an AKS cluster with Arc enabled GitOps

## Beta Labs

> These labs are work in progress and may not be fully documented

- [Deploy Res-Edge Data Service Lab](./labs/beta-labs/res-edge-labs/deploy-res-edge/README.md#inner-loop-with-res-edge): Deploy Resilient Edge Data Service to Codespaces
- [Ring Deployment Lab](./labs/beta-labs/res-edge-labs/kustomize/README.md#ring-deployment): Ring deployment using Res-Edge and Kustomize

## Support

This project uses GitHub Issues to track bugs and feature requests. Please search the existing issues before filing new issues to avoid duplicates.  For new issues, file your bug or feature request as a new issue.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.
