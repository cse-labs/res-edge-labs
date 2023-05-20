# Resilient Edge Labs

## Introduction

Kubernetes is hard. Getting started and set up for the first time can take weeks to get right. Managing deployments on a fleet of Kubernetes clusters on the edge brings even more challenges.

Kubernetes in Codespaces (KiC) is a `game-changer` for the end-to-end Kubernetes development lifecycle from a local cluster to deployments on the edge. KiC reduces the initial friction and empowers the developer to get started and deployed to a dev/test environment within minutes. The pre-configured Codespaces environment includes a `Kubernetes` cluster and a custom CLI (`kic`) that help streamline the initial Kubernetes learning curve.

These labs walks through the rich end-to-end developer experience of KiC. The labs start by walking you through creating, building, testing, and deploying an application on a local cluster running inside Codespaces ([inner-loop](./README.md#inner-loop)) with a complete [CNCF observability](https://landscape.cncf.io/card-mode?category=observability-and-analysis&project=graduated,incubating,sandbox) stack ([Grafana](https://grafana.com/), [Prometheus](https://prometheus.io/docs/introduction/overview/), and [Fluent Bit](https://fluentbit.io/)).

## Prerequisites

- GitHub Codespaces access
- An Azure subscription with owner access
  - A [free Azure subscription](https://azure.microsoft.com/en-in/free/) will work for exploration
  - Some advanced scenarios also require AAD permissions

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

Many of these labs use environment variables, using the export functionality. If you wish, you can edit the kic.env file to persist exported environment variables across terminal sessions. Just add the same "export FOO=BAR" lines to your kic.env file.

```bash

code ~/kic.env

# reload kic.env
source "$HOME/kic.env"

```

## Getting Started

The first lab is an `inner-loop` lab that introduces Codespaces and the various pre-installed components and tools

> The lab is the basis for all future labs, so you should go through the lab a few times until you're comfortable with Codespaces and the tools

- Create a K8s cluster in the Codespace
- Build, deploy, and test a new application
- Deploy a CNCF observability stack
  - Fluent Bit (log forwarding)
  - Prometheus (metrics)
  - Grafana (dashboards)
- Generate and observe synthetic load
- Run and observe load tests

[Lab](./labs/inner-loop.md#inner-loop): Introduction to Kubernetes in Codespaces

## Deploy Data Service

> This lab is a prerequisite for future labs

[Resilient Edge (Res-Edge)](./docs/Res-Edge-Overview.md) is a composition of tools designed to streamline application manageability across a highly distributed application platform. The objective is to leverage a small platform team to support a highly distributed ecosystem of clusters and apps. We will step through how Resilient Edge (Res-Edge) addresses the following capabilities:

- Managing Clusters at Scale
- Matching Applications and Clusters
- Configuration Proliferation
- Connectivity

[Lab](./labs/deploy-res-edge.md#inner-loop-with-res-edge): Deploy Resilient Edge Data Service to Codespaces

## Assign a Group to a Namespace

> This lab is a prerequisite for the Kustomize lab

- Res-Edge uses `Groups` to allow applying Kubernetes manifests to multiple `Clusters` at the same time
- In order for a `Namespace` and associated `Application(s)` to deploy to a `Cluster`, you must `assign` a `Group(s)` to the `Namespace`
- This lab will demonstrate:
  - Assigning the `store Group` to the `imdb Namespace`
  - Running cicd locally
  - Reviewing, committing, and pushing the changes to your GitHub repo

[Lab](./labs/assign-group-to-namespace.md#assign-group-to-namespace): Assign a Group to a Namespace

## Ring Deployment with Kustomize

Application teams often want to deploy new versions of their app(s) to a growing subset of clusters. Res-Edge uses [Kustomize](https://kubectl.docs.kubernetes.io/guides/introduction/kustomize/), `Groups`, `Namespaces`, and `Applications` to provide `ring deployments`. This lab demonstrates ring deployment using Res-Edge and Kustomize.

[Lab](./labs/ring-deployment-with-kustomize.md#ring-deployment-with-kustomize): Ring deployment with Res-Edge and Kustomize

## Support

This project uses GitHub Issues to track bugs and feature requests. Please search the existing issues before filing new issues to avoid duplicates.  For new issues, file your bug or feature request as a new issue.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.
