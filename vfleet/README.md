# Virtual Cluster Spike

- Work in Progress

```bash

# make sure vcluster CLI is installed
vcluster -v

# from on-create.sh

echo "installing vcluster CLI"
curl -L -o vcluster "https://github.com/loft-sh/vcluster/releases/latest/download/vcluster-linux-amd64"
sudo install -c -m 0755 vcluster /usr/local/bin
rm -f vcluster

```

```bash

# start in this directory
cd "$KIC_BASE/vfleet"

# create your virtual fleet
# set the NodePort to 32100 + cluster ID
./create.sh 32101 central-la-nola-2301 &
./create.sh 32104 central-tx-atx-2301 &
./create.sh 32107 east-ga-atl-2301 &
./create.sh 32110 east-nc-clt-2301 &
./create.sh 32113 west-ca-sd-2301 &
./create.sh 32116 west-wa-sea-2301

# wait for pods
kic pods --watch

# deploy flux
./vflux.sh central-la-nola-2301 &
./vflux.sh central-tx-atx-2301 &
./vflux.sh east-ga-atl-2301 &
./vflux.sh east-nc-clt-2301 &
./vflux.sh west-ca-sd-2301 &
./vflux.sh west-wa-sea-2301

# wait for all jobs to finish
jobs

# force Flux to sync
KUBECONFIG=$HOME/.kube/central-la-nola-2301.yaml kic sync &
KUBECONFIG=$HOME/.kube/central-tx-atx-2301.yaml kic sync &
KUBECONFIG=$HOME/.kube/east-ga-atl-2301.yaml kic sync &
KUBECONFIG=$HOME/.kube/east-nc-clt-2301.yaml kic sync &
KUBECONFIG=$HOME/.kube/west-ca-sd-2301.yaml kic sync &
KUBECONFIG=$HOME/.kube/west-wa-sea-2301.yaml kic sync

# check the pods on each cluster
echo "central-la-nola-2301" && KUBECONFIG=$HOME/.kube/central-la-nola-2301.yaml kic pods && echo ""
echo "central-tx-atx-2301" && KUBECONFIG=$HOME/.kube/central-tx-atx-2301.yaml kic pods && echo ""
echo "east-ga-atl-2301" && KUBECONFIG=$HOME/.kube/east-ga-atl-2301.yaml kic pods && echo ""
echo "east-nc-clt-2301" && KUBECONFIG=$HOME/.kube/east-nc-clt-2301.yaml kic pods && echo ""
echo "west-ca-sd-2301" && KUBECONFIG=$HOME/.kube/west-ca-sd-2301.yaml kic pods && echo ""
echo "west-wa-sea-2301" && KUBECONFIG=$HOME/.kube/west-wa-sea-2301.yaml kic pods && echo ""

# delete your fleet
vcluster delete central-la-nola-2301 &
vcluster delete central-tx-atx-2301 &
vcluster delete east-ga-atl-2301 &
vcluster delete east-nc-clt-2301 &
vcluster delete west-ca-sd-2301 &
vcluster delete west-wa-sea-2301

# wait for clusters to delete
kic pods --watch

```
