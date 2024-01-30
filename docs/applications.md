# Applications

## Overview

An application represents a workload that can be deployed to one or more clusters.  Applications are currently deployed to clusters based on their associated Namespace.  The application will get the list of clusters to deploy to from the clusters that are associated to the namespace via the [Included Clusters Expression](/docs/included_clusters_expression.md).

## Properties

|Name|Description|
|----|-----------|
|Name|Name of the application.|
|Description|Application Description|
|Namespace|Association to a [namespace](/docs/namespaces.md) - an application can be associated to a maximum of one namespace.|
|Owner|Owner of the application, this field does not currently enforce any functionality in Res-Edge|
|Gitops Repo Path|Path to the application deployment template directory in the GitOps repo|
|Gitops PAT||
|Metadata|This field holds a collection of key/value pairs that can be used as substitute values in deployment template files|

## Functionality
