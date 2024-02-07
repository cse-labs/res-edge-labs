# Res-Edge (Resilient Edge)

## Overview

Res-Edge is a system designed to facilitate the management of application deployments across one or multiple Kubernetes clusters by leveraging GitOps principles(/docs/gitops.md). It aims to simplify the process of controlling which applications are deployed to each cluster within the fleet(s).

Res-Edge features two primary components:

1. A data store designed to maintain an inventory of clusters and applications, including the relationships that define which application(s) are deployed to which cluster(s).
2. An automation process that utilizes the inventory data to generate manifests and manage a GitOps repository.

## Inventory Maintenance

Maintaining an accurate inventory of clusters, applications, and their relationships is crucial for the effective deployment and management of applications across a fleet of Kubernetes clusters. This section guides you through the necessary steps to define and organize your deployment architecture within Res-Edge:

- [Create Cluster Definition(s):](/docs/clusters.md) Define individual clusters to manage deployments more efficiently. This step involves specifying the configurations of each Kubernetes cluster in your fleet.
- [Cluster Group(s)/Hierarchies:](/docs/groups.md) Organize your clusters into groups or hierarchies to streamline the management process and deployment strategies. This organization helps in applying common configurations at the group level.
- [Create Namespace(s):](/docs/namespaces.md) Provides a mechanism for enabling a business organization to control which apps can be deployed by that organization.
- [Create Application(s) and Assign to a Namespace:](/docs/applications.md) Define the applications to be deployed and assign them to the appropriate namespaces. This step ensures that applications are organized and deployed within the correct scope and access level.

## Automation Step

Once applications, namespaces, and clusters/cluster groups have been defined, the automation step will maintain the GitOps repository. It accomplishes this by:

- Generating application manifests with template placeholders substituted by values from the application.
- Placing these manifests in the correct GitOps repository location.

The Res-Edge data service will create and maintain the GitOps directory structure for the clusters based on the items created above.

> **NOTE:** Res-Edge relies on a GitOps tool to synchronize the Kubernetes cluster state with the state described in the GitOps directory structure.

## GitOps With Res-Edge

![Gitops Process Diagram](/docs/images/res-edge-gitops.png "GitOps Flow")
