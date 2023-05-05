# Resilient Edge - Overview

Customers are applying DevOps patterns to build and evolve platforms for scalable application development. Customers often begin with organizing an application platform for many applications around a few larger clusters on premises and/or hosted with one or more cloud providers. Typically, these customers are managing around 1,000 applications on fewer than 10 clusters and these are the target customers for [Azure Fleet Manager](https://learn.microsoft.com/en-us/azure/kubernetes-fleet/overview).

We have encountered Retail and Manufacturing customers with an inverted challenge: having a small set (tens to hundreds) of applications that need to operate across a large number (many thousands) of edge clusters. For example, a customer has thousands of store locations to which they need to deploy a set of in-store applications. The scale of cluster management and associated application deployment stresses the typical cluster and application management tooling with which we have become familiar. New pressure points introduced by the inversion include:

- Managing Clusters at Scale - How can we configure and observe 30k clusters?
- Matching Applications and Clusters - Which apps are or should be running where?
- Configuration Proliferation - How do we deal with 6M configuration files?
- Connectivity - How do we deal with unreliable or constrained bandwidth?

Resilient Edge is a composition of tools designed to streamline application manageability across a highly distributed application platform. The objective is to leverage a small platform team to support a highly distributed ecosystem of clusters and apps. We will step through how Resilient Edge (Res-Edge) addresses each pressure point listed above.

## Cluster Management at Scale

Platform operators with thousands to tens of thousands of clusters need additional tooling to reduce the complexity of managing those clusters and the applications running on them:

- Maintaining an inventory of clusters
- Organizing clusters into groups, in particular groups related to business hierarchies like geography or business units
- Defining policies and assigning them to clusters based on business needs
- Observing clusters and apps based on business hierarchies

Res-Edge plans to address these gaps with the addition of a centralized "Inventory Service" and associated operator workloads running within clusters to provision, manage, apply policy to, and observe clusters in groups instead of individually. A centralized Inventory service will follow standard GitOps patterns, however, these are now orchestrated on groups of clusters providing platform operators the necessary levers needed to operate on many clusters at once instead of individually.

A key capability for cluster groups is the ability for platform operators to define hierarchies that align with business needs or scenarios. Business aligned groups will help platform operators organize infrastructure to match business expectations, and when plumbed into the observability layer, analyzing application and cluster operations by business scenario much easier.

Reducing the overall number of manageability touchpoints for platform operators is a key requirement to enable small teams to be able to successfully support large numbers of clusters and application teams.

## Application/Cluster Matching

With clusters now organized into groups to make them more manageable, you now need to be able to deploy application workloads to those clusters. Given the dynamic nature of application requirements, cluster resources, and observability requirements at this scale, Res-Edge introduces a centralized "Namespace Service" enabling application and platforms teams to collaborate around ensuring:

- Cluster resources are not over-subscribed by specifying declarative policy
- Applications with interdependencies are treated as a set
- Sets of applications can be easily identified, monitored, and managed

Platform operators will be able to use Namespace tooling to interact with a Namespace service to create namespaces, specify resource policies for them, manage association of specific applications to a namespace, and finally, assign namespaces to sets of clusters using the Inventory service (see above).

Application owners will use the namespace service to register their applications and request applications be assigned to specific namespaces. Namespaces are also enabled through the observability layer to help application owners identify their apps and other apps within them.

might want to add that this enables charge back based on capacity

It's kind of a secondary concern, as in you could still accomplish chargebacks with consistent telemetry, it just takes extra steps. Do you feel this qualifies as a first order concern? For example, would you suggest a customer invest in putting NS infra in place explicitly and only for the purpose of simplifying attribution?

customers have asked for charge back - McD wanted 39K bills sent to each store / franchisee.

Let's discuss, this is only a part of a chargeback scheme

We agreed to leave this off

This Namespace as a Service concept simplifies interactions between platform operators and application owners, reducing the management burden of supporting apps running on many thousands of clusters.

## Connectivity

When dealing with a handful of clusters that are generally highly available and always online, connectivity to clusters is not usually a concern. With many thousands of clusters, even small connectivity blips can result in difficulties when trying to manage application and cluster lifecycle operations at scale. The key to successfully ensuring manageability operations succeed across a diverse set of heterogeneous clusters is by building in resiliency and robust remediation protocols. Additional complexity can come into play if connectivity is permanently constrained such as a boat floating out on the open ocean connecting through spotty satellite coverage.

Res-Edge plans to address connectivity lapses and constraints through hardening GitOps infrastructure to ensure eventual consistency of a "last known good" configuration is enforced, ensure unnecessary or duplicated data transfer is avoided or minimized, and caching is enabled where appropriate to minimize disruptions of cluster and application management operations due to connectivity issues.

Additional work around observability is necessary to help further improve the signal to noise ratio for traffic relying on connectivity outside of the cluster by employing filtering, prioritization, batching, or fully disconnected capabilities.

## Configuration Proliferation

Today, most GitOps and CI/CD workflows rely on fully materialized configuration file sets. When dealing with the scale of 100 apps running on 30k clusters, individually managing a configuration file for every app/cluster permutation within source control becomes a scale pressure point as well as a major burden for platform operators. Res-Edge plans to minimize the proliferation/explosion of configuration files necessary to operate across many clusters by relying on base configuration files and overlay [kustomizations](https://kustomize.io/) which are leveraged at deployment time to hydrate a fully materialized configuration when deploying an application to a specific cluster. As a result, application owners need only specify a base template for their application which will work across clusters and one kustomization for each change applied across any number of clusters.

Key capabilities for configuration templates include:

- Extensible to enable observability layers
- Enables deployment policy definition (e.g., update/rollout windows)
- Supports Inventory/Namespace concepts for the purposes of targeting/deployment

When dealing with the potential of millions of configuration files, it is imperative to decouple source control systems which are not designed for this scale from the GitOps workflow.

## Summary

Res-Edge plans to address the major challenges of operating apps across many clusters by providing a composition of complementary tools:

1. Inventory
   1. Organize clusters by business hierarchies
   1. Track platform and apps assets
   1. Service, Tooling/CLI
1. Namespace as a Service
   1. Simplify app team interface to platform
   1. Scalable policy management
   1. Service, Tooling/CLI
1. Configuration Service
   1. Scale GitOps via business hierarchies and kustomize
   1. Cluster operator

Together these tools address the major paint points we anticipate. For more information and details please see {link}.

## Other Known Approaches

- Azure Fleet Manager, combined with Arc, Azure Monitor Lite, and other offerings, might eventually focus on edge cluster scenarios with a similar approach, particularly use of a custom operator to avoid Configuration Proliferation and GitOps bottlenecks.
- [Chik-fil-a has tooling](https://medium.com/chick-fil-atech/enterprise-restaurant-compute-f5e2fd63d20f) that distributes each configuration pull request (PR) to the individual GitOps repos for all stores for which the change is intended.
- [Rancher Fleet](https://fleet.rancher.io/) presents a different approach to leverage for large-scale edge cluster management. Rancher Fleet groups allows for managing clusters in groups, makes use of deployment bundles, and uses GateKeeper to simplify application and policy management From the Fleet documentation: "Note that cluster labels and overlays are critical features in Fleet as they determine which clusters will get each part of the bundle."
- Several crews have tried different things for specific engagements. Here's an example of a crew that built a REST service on top of GitOps to help with a certain amount of edge cluster scale: https://dev.azure.com/CSECodeHub/516879%20-%20BASF%20Pump%20Monitoring/\_wiki/wikis/EFO\_Wiki\_Template/32398/What-we-delivered
