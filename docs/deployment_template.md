# Deployoment Template Directory

A Deployment Template Directory is a directory with a collection of YAML files that can contain placeholders.  These deployment template directories are kept in the GitOps repository.  These placeholders are replaced by values configured in certain Res-Edge objects as metadata.  

Res-Edge objects that can hold metadata are:

- Applications
- Namespaces
- Clusters

Placeholders in yaml templates are defined in the following manner:
rea.namespace.(metadata-key-name)
rea.application.(metadata-key-name)
rea.cluster.(metadata-key-name)

Example yaml template with placeholders

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rea.application.name
  namespace: rea.namespace.name
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    ingress.kubernetes.io/force-ssl-redirect: "false"
    kubernetes.io/ingress.class: nginx
    kubernetes.io/tls-acme: "true"

spec:
  rules:
  - host: rea.application.name.rea.cluster.name.res-edge.com
    http:
      paths:
      - pathType: Prefix
        path: /
        backend:
          service:
            name: rea.application.name
            port:
              number: 8080
```

## Directory Structure for Deployment Template

The following is an illustration of what a deployment template directory might look like.  Overlays are not required and Res-Edge will apply the overlay with the highest version.

```bash
Application
|___base
|    |___kustomization.yaml
|    |___manifest_1.yaml
|    |___manifest_2.yaml
|    | .
|    | .
|    | .
|    |___manifest_N.yaml
|___overlays
|    |___version 1
|    |   |___kustomization.yaml
|    |   |___manifest_1.yaml
|    |   |___manifest_2.yaml
|    |   | .
|    |   | .
|    |   | .
|    |   |___manifest_N.yaml
|    |___version 2
|        |___kustomization.yaml
|        |___manifest_1.yaml
|        |___manifest_2.yaml
|        | .
|        | .
|        | .
|        |___manifest_N.yaml
```

The kustomization.yaml file will define which files within the deployment template directory will be applied and in what order they will be applied.
