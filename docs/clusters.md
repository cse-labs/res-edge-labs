# Clusters

## Overview

A cluster represents a Kubernetes cluster. This creates a directory for the cluster in the GitOps repository.

## Properties

|Name|Description|
|----|-----------|
|Name|Name of the cluster|
|Description|Description of the cluster|
|Time Zone|Timezone for the cluster, used in conjunction with deployment window definition to control when deployments can occur|
|Group Membership|List of groups that this cluster is a part of|
|Metadata|This field holds a collection of key/value pairs that can be used as substitute values in deployment template files|
|Deployment Window Start Time|Defines the start time of the deployment window|
|Deployment Window End Time|Defines the end time of the deployment window|
