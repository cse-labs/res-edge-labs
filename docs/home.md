# Resilent Edge Overview

Resilient Edge (Res-Edge) is a composition of tools designed to streamline application manageability across a highly distributed application platform. The objective is to leverage a small platform team to support a highly distributed ecosystem of clusters and apps.

- Developer Productivity
  - Enable inner-loop and outer-loop development processes that provide a robust and low-friction way to manage the full code lifecycle which allows customers to evolve their SDLC to meet their business needs.
  - Res-Edge inner-loop is an extension of the Kubernetes in Codespaces inner-loop that we have been successful with for over 3 years. The main extension is the ability to deploy, test, and observe Res-Edge within a developer's Dev Box, Codespace, or Windows machine. This allows the Platform Team to get Res-Edge running with minimal friction - usually in under an hour.
- Scalable Operations on the Edge
  - Enable customers to manage their distributed environments across geographies, franchisees, and stores in a way that maximizes flexibility, resiliency, and velocity while minimizing costs.
  - Res-Edge use Arc enabled GitOps as a pull model for deploying the correct workloads to the correct clusters while protecting against "drift".

The Edge brings unique challenges. One of the first challenges is rather than a few large clusters the Edge has 10s of thousands of small clusters connected by a mostly reliable network. Our large retail customers have up to 60K stores. Our current tooling is not designed to handle thousands of clusters.

Retailers like Walmart and CFA deploy multiple times per day to the Edge. This is a key differentiator vs. other industries like Manufacturing. Retail also has a constant stream of data flowing back to the Data Center.

## Res-Edge System Diagram

![image](/docs/images/res-edge-diagram.drawio.png)

- Res-Edge Data Service
  - The Data Service is a REST API and is the core of the system
  - The Data Service is flexible enough to enable additional scenarios and rigid enough to be repeatable
  - The CLI, Dashboard, and Automation use the Data Service
  - We expect customers will build tools that use the Data Service
- Data Storage
  - SQL Server is used to store the data
- Automation
  - Automation combines the values from the Data Service with the GitOps repo to create the appropriate Kubernetes manifests for each cluster
  - These manifests are applied by Flux running on each Cluster
- Res-Edge Dashboard
  - The Dashboard is a Web UI used by the Platform and Application teams
- CLI
  - The CLI is used by advanced users and for automation
- Arc Enabled Store
  - Each store runs one or more Kubernetes clusters
  - Arc Enabled GitOps is used to deploy the Automation results to each store
  - Arc Enabled GitOps uses Flux which is a pull model

## Key Requirements

- Security
  - RBAC or similar controls
  - Definable sign-off processes
  - Audit
  - Policies
- Observability
  - Logs, metrics, and traces
  - Granular control over what gets shipped to the cloud as well as when
- Automation
  - Maintaining "millions" of GitOps files in the GitOps repo is error prone and doesn't scale
  - Verifying what is running in the store with what should be running
  - Ensuring an application isn't deployed where local law prohibits
  - Support a "pull model" for network QoS and availability
  - Support "last known good" in the event of a natural disaster without a reliable network
    - Maximize the "time to open after an event"
- Centralized Configuration
  - Enforce standards and reusability
- Rich Deployment Selection
  - "deploy to all of the company owned, large stores in the northeastern US that have a multi-lane divethrough and an Acme3000 or Acme3001 smart grill"
- Deployment Windows
  - Retailers need to be able to schedule deployments on a store by store basis based on operating hours
  - The Platform Team needs to be able to implement "deployment freezes" for events like Black Friday
  - With the proper sign-off, both must be able to be over-ridden
    - At the Cluster (store) level or at the Application level
- Ring Based Deployments
  - Define and deploy to rings (beta, pilot, etc)
  - Configurable authorization workflows
  - Automatically deploy to the next ring if the current deployment is stable for a time quantum
    - This requires integration with Observability
- Multiple, Jagged Business Grouping
  - Most Retailers have multiple Business groups that they want to represent
    - Geographic is the most common
      - /stores/us/central/tx/austin
    - Franchisee
      - Corporate store
      - Franchise 123
      - Master Franchise 456
    - Marketing
      - Language and demographics
      - Local channels (with language)
    - Plan-o-Gram
      - Swimsuit section in Florida vs. Alaska
      - "McRib" in the South
    - Presence of IoT Devices
      - Cameras
      - Smart grills, ovens, fryers, soda fountains, shake machines
      - Food assembly devices
    - Delivery
      - Uber Eats, GrubHub, store, curbside
