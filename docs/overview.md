# Res-Edge (Resilient Edge) - Overview

Res-edge is a system that facilitates managing application deployments to fleet or fleets of Kubernetes clusters by leveraging [GitOps principles](/docs/gitops.md). Res-edge is designed to simplify the process of managing what applications are deployed to an individual cluster or multiple clusters in the fleet(s).

By using GitOps principles, Res-Edge provides a reliable and scalable way to manage a fleet or fleets of Kubernetes clusters and applications. The system ensures that the desired state of each cluster (what applications are deployed to the cluster) is always maintained, and that the deployments are performed in a consistent and repeatable manner. GitOps principles ensure that there is a picture of what is currently deployed and an audit history of what has previously been deployed to what cluster(s).  GitOps also provides the ability to revert the cluster to a prior state.

*The name Res-Edge comes from the initial use case for the project, which was to help manage edge nodes for retail use cases, where the number of clusters in the fleet requires massive scale.  This though does not preclude Res-Edge from being extremely useful in a non-edge environment.*

## Res-Edge Features

Res-Edge is designed to address the following needs when used in conjunction with a GitOps tool/operator like [Flux](https://fluxcd.io) or [Argo CD](https://fluxcd.io/):

1. Inventory
   1. Organize clusters by business hierarchies
   1. Manage and track application deployments to clusters
1. Namespace as a Service
   1. Simplify app team interface to platform
   1. Scalable policy management
1. Configuration Service
   1. Scale GitOps via business hierarchies and kustomize
1. CLI

## Other Known Approaches

- Azure Fleet Manager, combined with Arc, Azure Monitor Lite, and other offerings, might eventually focus on edge cluster scenarios with a similar approach, particularly use of a custom operator to avoid Configuration Proliferation and GitOps bottlenecks.
- [Chik-fil-a has tooling](https://medium.com/chick-fil-atech/enterprise-restaurant-compute-f5e2fd63d20f) that distributes each configuration pull request (PR) to the individual GitOps repos for all stores for which the change is intended.
- [Rancher Fleet](https://fleet.rancher.io/) presents a different approach to leverage for large-scale edge cluster management. Rancher Fleet groups allows for managing clusters in groups, makes use of deployment bundles, and uses GateKeeper to simplify application and policy management From the Fleet documentation: "Note that cluster labels and overlays are critical features in Fleet as they determine which clusters will get each part of the bundle."
