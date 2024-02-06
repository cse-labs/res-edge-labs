# Res-Edge (Resilient Edge)

## Overview

Res-edge is a system that facilitates managing application deployments to a fleet or fleets of Kubernetes clusters by leveraging [GitOps principles](/docs/gitops.md). Res-edge is designed to simplify the process of managing what applications are deployed to an individual cluster or multiple clusters in the fleet(s).

Res-Edge has two main components.

1. A data store that allows for maintaining an inventory of clusters and applications and the relationships that define what application(s) are deployed to which cluster(s).
2. An automation process that uses the inventory data to generate manifests and maintain a GitOps repository.

## Inventory Maintenance

- [Create Cluster Definition(s)](/docs/clusters.md) and [Cluster Group(s)/Hierarchies](/docs/groups.md)
- [Create Namespace(s)](/docs/namespaces.md)
- [Create Application(s) and Assign to a Namespace](/docs/applications.md)

## Automation Step

Once applications, namespaces, and clusters/cluster groups have been defined the automation step will maintain the gitops repo.  It will do this by:

- Generating application manifests with template placeholders substituted by values from the application
- Placing these manifests in the correct GitOps repo location

The Res-Edge data service will create/maintain the GitOps directory structure for the clusters based on the items created above.

> **NOTE:** Res-Edge relies on a GitOps tool to synchronize the k8s cluster state to the state described in the GitOps directory structure.

## GitOps With Res-Edge

![Gitops Process Diagram](/docs/images/res-edge-gitops.png "GitOps Flow")
