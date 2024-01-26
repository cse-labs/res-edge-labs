# Application/Cluster Matching

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
