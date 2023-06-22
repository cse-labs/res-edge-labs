#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ]; then
    echo "usage: ./create.sh nodePort clusterName"
    echo "       nodePort should be in [32101-32199]"
    echo ""
    exit 1
fi

vcluster create $2 -n vfleet --connect=false
sleep 5

cat <<EOF | kubectl create -f -
apiVersion: v1
kind: Service
metadata:
  name: $2-nodeport
  namespace: vfleet
spec:
  selector:
    app: vcluster
    release: $2
  ports:
    - name: https
      nodePort: $1
      port: 443
      targetPort: 8443
      protocol: TCP
  type: NodePort
EOF

vcluster connect $2 -n vfleet --kube-config ~/.kube/$2.yaml --update-current=false --server=https://127.0.0.1:$1

KUBECONFIG=~/.kube/$2.yaml kubectl get ns
