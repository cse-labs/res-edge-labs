# Res-Edge (Resilient Edge)

## Overview

Res-edge is a system that facilitates managing application deployments to a fleet or fleets of Kubernetes clusters by leveraging [GitOps principles](/docs/gitops.md). Res-edge is designed to simplify the process of managing what applications are deployed to an individual cluster or multiple clusters in the fleet(s).

By using GitOps principles, Res-Edge provides a reliable and scalable way to manage a fleet or fleets of Kubernetes clusters and applications. The system ensures that the desired state of each cluster (what applications are deployed to the cluster) is always maintained, and that the deployments are performed in a consistent and repeatable manner. GitOps principles ensure that there is a picture of what is currently deployed and an audit history of what has previously been deployed to what cluster(s).  GitOps also provides the ability to revert the cluster to a prior state.

## Res-Edge Process Overview

- [Create Application Deployment Template Directory](/docs/deployment_template.md)
- [Create Cluster Definition(s)](/docs/clusters.md) and [Cluster Group(s)/Hierarchies](/docs/groups.md)
- [Create Namespace(s)](/docs/namespaces.md)
- [Create Application(s) and Assign to a Namespace](/docs/applications.md)

The Res-Edge data service will create/maintain the GitOps directory structure for the clusters based on the items created above.

> **NOTE:** Res-Edge relies on a GitOps tool to synchronize the k8s cluster state to the state described in the GitOps directory structure.

## GitOps With Res-Edge

![Gitops Process Diagram](/docs/images/res-edge-gitops.png "GitOps Flow")
