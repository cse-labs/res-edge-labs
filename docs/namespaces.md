# Namespaces

A namespace provides a mechanism that enables a business organization to control which apps can be deployed by it.

## Overview

Namespaces are designed to give a business entity control of what applications are to be deployed to what clusters. This is accomplished by specifying an Included Clusters Expression to select what clusters are associated with the namespace.  A namespace is associated with an application providing the  relationship between the application and the cluster(s) for which the deployment manifests will begenerated.

## Properties

|Name|Description|
|----|-----------|
|Name|Name of the namespace|
|Description|Description of the namespace|
|Included Clusters Expression|Spefifies what clusters are associated with this namespace - expression is always evaluated at run time meaning the list of clusters associated with the namespace is dynamic based on inventory setup at time of evalutation|
|Override Deployment Window|used to overwrite deployment windows set at the cluster level|
|Owners|Owners of the namespace|
|Metadata|Kev value pairs available for usage in deployment templates|
