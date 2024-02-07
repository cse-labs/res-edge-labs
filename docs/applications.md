# Applications

## Overview

An application represents a workload that can be deployed to one or more clusters. Applications are deployed to clusters based on their associated Namespace. The application determines the list of clusters to deploy to from those associated with the namespace via the [Included Clusters Expression](/docs/included_clusters_expression.md).

## Properties

|Name|Description|
|----|-----------|
|Name| Name of the application|
|Description| Application Description|
|Namespace| Association to a [namespace](/docs/namespaces.md) - an application can be associated with at most one namespace|
|Owner| Owner of the application; this field currently does not enforce any functionality in Res-Edge|
|Gitops Path| Path to the application deployment template directory in the GitOps repo|
|Metadata| Holds a collection of key/value pairs that can be used as substitute values in deployment template files|
