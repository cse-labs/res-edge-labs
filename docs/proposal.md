# P&G Proposal

P&G needs to run applications on the edge for predictive quality, predictive maintenance, controlled release, adaptive process control, energy & sustainability management, and move OT (operational technology) data to the cloud to enable offline analytics. P&G envisions utilizing a standardized, scalable, sustainable, and secure Industrial IoT platform that meets the needs of use cases across all business units. In order to manage deployment at scale, P&G has previously shared "[requirements for a "Configuration Management"](https://microsoft.sharepoint-df.com/:w:/t/AzureOneEdgeTeam/EfpdXPfTXchPhBEGNiiBWhYBKG9_etFTzpTCMDM1-cdWkw?e=ipVMgH) solution and Microsoft is looking to establish a scalable solution to replace the custom solution developed by P&G.

The technical solution we have to build is a hierarchical configuration database and required delivery pipeline components that enable the configuration management of Kubernetes based applications. That includes automation capabilities to roll out changes and monitor version status to and from all participating nodes. More on the specific investments needed can be found later in this document.

Microsoft is suggesting making this investment in phases with the first delivery starting in February 2024. The goal of this approach is a) to provide value fast by addressing key issues first and b) to learn from actual deployments to make better product decisions. The below shows the scope and timing of these investments. This is based on input from [P&G's MVP Success Criteria document](https://microsoft-my.sharepoint-df.com/:w:/p/svengru/Ee5AlgCj8WxKuc04rkazVkIBi0MRgwQi3eTFOcA7IPd4vw?e=V0azJ8).

- Evaluation phase – Delivered in February 2024
- Phase 1 – (timing to be updated in January 2024)
- Phase 2 – (timing to be updated in January 2024)

# Evaluation phase - February 2024

Microsoft is suggesting delivering an evaluation version and enabling P&G to deploy it to a few selected lines. It enables the below and will use the CSAD application as an example. This includes delivering monthly updates leading to the phase 1 MVP release. "Use case" and "Application" are used interchangeably in the remaining of the doc.

#### As the developer I can

- create and edit a Kubernetes configuration template for my use case. I provide default configuration values.
- expose plant/line specific configuration values to be supplied by equipment owners.
- store that template in a Git repository.
- use repeatable pattern guidance to avoid duplicate definitions of configuration values and enable automated hydration of templates.

#### As the equipment owner I can

- add equipment specific configuration values such as IP address, etc. Simple validation of configuration values is performed (e.g., IP address check or numeric range validation).
- select a use case (application configuration) from a list of available use cases for a specific line and assign it to the line.
- do the above in a UI that is appropriate for me.

#### As the line operator I can

- rollout a new application version and configuration values
- monitor the deployment and status of the use case.
- do "roll-back" by rolling forward the last valid deployment.
- do the above in a UI that is appropriate for me.

###
# Phase 1

Based on the learnings from the Evaluation Phase, the focus is on making investments to turn the Evaluation Phase into a product that can be deployed in production. I will include all the features from the evaluation phase and in addition meet the criteria below.

- The ability to configure "shared components" (e.g., one Wonderware adapter for multiple lines).
- End user authentication via Entra (Azure AD).
- All actions are logged (including changes to configurations and deployment activities), and it can be seen who made changes and when.
- As a model/application owner, I can see what versions of my model and currently deployed and be able to review the configuration.
- As a developer, I have basic tools available to "debug" deployment failures. This includes readable logs, and the ability to complete a deployment manifest for review (aka "preview") using the configuration defined in the UI.
- As the overall owner of the MDF Platform, I am confident that the resulting solution can be scaled to work for templates running on more than 100 lines with different configurations as well as for the complete set of use cases that P&G deploys.
- As a Line Operator I can correct failed deployments even if no cloud connectivity is available "Break Glass."
- As a Developer/Line Operator, I can test a configuration and validate prior to applying it to the Edge (Release validation).

- Ability to deploy use cases and/or updates across multiple plants (i.e., across the fleet). While normally a line operator will make the final decision, there are times when a change needs to be deployed to one or more plants/lines without line owner acknowledging. This would be done by a highly experienced individual with "developer skills" and comfortable with CLI. This individual would need to be able to validate (in bulk) that the change can be deployed for a list of lines/plants, and then be able to apply the change to those lines/plants where validation passed.

# Phase 2

Phase 2 focuses on refining the investments made in phase 1 and adds the following additional capabilities to meet P&Gs full set of requirements.

- The ability for developers to define "custom validation rules" for configuration in their templates.
- The ability to support nested clusters.
- The ability to set a trigger for when the use case (or updated version of that use case) should be ready for deployment. This means the containers are all downloaded and good to start, so that now the line operator can deploy the use case once staging is complete. This would work the same for "up versioning" a use case on a line.

- At any given time, it should be possible to view what is the currently applied configuration for a use case/application. Single source of Desired Configuration and Applied/Running Configuration.

# Assumptions

This proposal makes several technical assumptions that are stated below.

- A deployable unit must run on a single Kubernetes cluster.
- Deployment and configuration of Kubernetes itself, along with the underlying OS/Infrastructure is not in scope of this solution.
- Configuration/updates of devices/PLCs or anything outside of the Kubernetes cluster is out of scope.
- P&G's workloads will support being configured using industry standard Kubernetes tooling (i.e., Helm, Kubectl, etc.). Changes to P&G's workloads to support these tools will be the responsibility of P&G with guidance from Microsoft on how to implement key features such as file movement on the new AIO platform in a way compatible with the configuration tool.

# Key solution components

## Digital Manufacturing Solution Configuration

P&G needs to be able to assemble a solution, configure it specifically to a site & line, and deploy the solution.  The following capabilities need to be available:

- Define a Solution and its base configuration.
- For each Site and Line that is a deployment target, configure the solution specific to the use case, site, and production line.
- Deploy the solution for each of the targeted sites and lines.

There are 3 templates that help define the solution today in P&Gs IoT Edge based environment and a similar construct is needed for the new Kubernetes based platform.

- Core template - Defines the global config that applies to all use cases and/or deployments.
- Environment template – This template defines the configuration for the Site & Line. Line level, component topology layout.
- Use Case template – Defines the components and their configurations by Site.

The key here is to avoid the duplication of variables and configuration files. Each line will have different variables and a solution needs to be developed that makes it easy to abstract this complexity and allows a developer to create a new core template that can be applied across lines without the need to manually make changes for each line. The solution does, however, need to provide the ability for overrides should these become necessary. Not solving this issue would result in an enormous number of individual configuration files that are unmanageable. Another key requirement is the ability to have services/components shared by multiple lines in the same cluster.

Solving the above can be broken down into four **key components:**

Configuration store
 Application templates need to be able to scale across lines with each line having different configuration values (e.g., IP address, line name). It is critical that fixed values that are tied to a location, line or specific equipment are only defined once and referenced where needed. P&G would otherwise have to manually edit and maintain hundreds of thousands of configuration files as a result of having to describe hundreds of use cases across hundreds of lines.

The configuration store will solve this complexity by enabling developers and equipment owners to define the values in a single place so that templates can be hydrated with the correct values before deployment.

Once created, a template could be applied to a line without having the equipment owner do any manual value entries (unless values are not defined, yet).

Storing values in a Configuration store vs. a large number of configuration files also enables programmatic updates of values to ensure consistency and reduce the risk of errors.

Configuration generator

This component will generate the relevant Symphony files combining data and templates from the Configuration store. These Symphony files will then be checked into Git from which a normal GitOps process is started that results in the orchestrator driving the required changes on the edge.
 This component should be built as a plugin into the Config store so that extensibility is provided to meet other customer/scenarios that might require a differing representation of the Symphony files.

### Edge configuration deployment and change orchestrator "Symphony"

It consumes the Symphony files stored in the Git repository. The orchestrator will initiate an orchestration workflow, identifying what solution component to deploy and define the right order of deployment based on the dependencies of these components.

In the case of a change to the configuration files, following GitOps workflows, a new deployment will be initiated. This will support use cases like roll-back to an earlier configuration, or where a new local parameter has been updated and needs to be deployed. The orchestrator is constantly state seeking and prevents any drift vs. the defined solution template while respecting local overrides.

The orchestrator also maintains a local copy of working configurations to enable roll-back scenarios even without cloud connectivity.

This component will also be used to gate change approvals in future releases (understood to be not a high priority for P&G at this point in time).

### Persona appropriate user interface

**IT Developers** will use their familiar development tools and languages to create applications (use cases) to run on Kubernetes cluster. No UI will be created for developers. Developers will expose configurations that need to be supplied by **Equipment Owners** (for example, in a specific folder structure in git or in a database table or something else based on technical design). This is a great opportunity for future Copilot usage.

**Equipment Owners** manage the configuration of a given set of equipment in a plant. A UI will be provided for Equipment Owners to do the following -

- View the list of plants, lines, and applications that they have access to
- Allow them to configure the attributes of plants, lines, and plant/line specific application values as exposed by developers.
- Understand the meaning of each configuration through, for example, a brief tooltip.
- Get feedback on invalid configuration value in the UI as early as possible.
- Assign (not yet deploy) applications to run on specific lines.

**Line Operators** keep the line running. They deploy applications to their line and debug common issues. A UI will be provided for Line Operators to do the following:

- Deploy a new application, a new version of the application, or a newly updated configuration for an application.
- Monitor whether the application is healthy or not.
- Roll back the last deployment if it is not healthy.

**All personas** will also be able to access a UI based on their role to view deployment status, application health, and activity logs such as who did what and when.

Microsoft confidential, shared under NDA. For discussion purposes only.
