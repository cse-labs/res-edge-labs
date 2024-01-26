# What is GitOps

**GitOps** is a set of practices that allow developers to perform more IT operations-related tasks. It is an evolution of Infrastructure as Code (IaC) and a DevOps best practice that leverages Git as the single source of truth, and control mechanism for creating, updating, and deleting system architecture. GitOps ensures that a system’s cloud infrastructure is immediately reproducible based on the state of a Git repository. Pull requests modify the state of the Git repository. Once approved and merged, the pull requests will automatically reconfigure and sync the live infrastructure to the state of the repository. This live syncing pull request workflow is the core essence of GitOps.

GitOps is an incredibly powerful workflow pattern for managing modern cloud infrastructure. It replaces manual processes for provisioning and configuring infrastructure with automation. Developers can declare service-level objectives as part of their application code and have the infrastructure automatically scale to maintain these objectives. GitOps delivers standardized application development workflows, enhanced security for upfront application requirement setups, increased reliability with Git-based version control and visibility, and consistency across clusters, cloud platforms, and on-premise setups.

In summary, GitOps is a DevOps best practice that leverages Git as the single source of truth for creating, updating, and deleting system architecture. It is a powerful workflow pattern that replaces manual processes with automation, delivering standardized application development workflows, enhanced security, increased reliability, and consistency across clusters, cloud platforms, and on-premise setups.

When dealing with a large number of clusters or applications, managing GitOps repository/repositries can be come a challenge.  This is where [Res-Edge](readme.md) can become a valuable tool in your toolbox.

## GitOps Flow With Res-Edge

![Gitops Process Diagram](/docs/images/gitops.jpeg "GitOps Flow")
