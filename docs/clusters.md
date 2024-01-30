# Clusters

## Overview

A cluster is a representation of a kubernetes cluster. This will create a directory for the cluster in the GitOps repository.  

## Properties

|Name|Description|
|----|-----------|
|Name|Name of the cluster|
|Description|Description of the cluster|
|Time Zone|Timezone for the cluster, this will be used in conjunction with deployment window definition to control when deployments can happen|
|Group Membership|List of groups that this cluster a part of.|
|Metadata|This field holds a collection of key/value pairs that can be used as substitute values in deployment template files|
|Deployment Window Start Time|Defines the start time of the deployment window.|
|Deployment Window End Time|Defines the end time of the deployment window.|
