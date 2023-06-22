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

./create.sh 32102 central-la-nola-2302 &
./create.sh 32105 central-tx-atx-2302 &
./create.sh 32108 east-ga-atl-2302 &
./create.sh 32111 east-nc-clt-2302 &
./create.sh 32114 west-ca-sd-2302 &
./create.sh 32117 west-wa-sea-2302

./create.sh 32103 central-la-nola-2303 &
./create.sh 32106 central-tx-atx-2303 &
./create.sh 32109 east-ga-atl-2303 &
./create.sh 32112 east-nc-clt-2303 &
./create.sh 32115 west-ca-sd-2303 &
./create.sh 32118 west-wa-sea-2303

# wait for pods
kic pods --watch

# deploy flux
./vflux.sh central-la-nola-2301 &
./vflux.sh central-tx-atx-2301 &
./vflux.sh east-ga-atl-2301 &
./vflux.sh east-nc-clt-2301 &
./vflux.sh west-ca-sd-2301 &
./vflux.sh west-wa-sea-2301

./vflux.sh central-la-nola-2302 &
./vflux.sh central-tx-atx-2302 &
./vflux.sh east-ga-atl-2302 &
./vflux.sh east-nc-clt-2302 &
./vflux.sh west-ca-sd-2302 &
./vflux.sh west-wa-sea-2302

./vflux.sh central-la-nola-2303 &
./vflux.sh central-tx-atx-2303 &
./vflux.sh east-ga-atl-2303 &
./vflux.sh east-nc-clt-2303 &
./vflux.sh west-ca-sd-2303 &
./vflux.sh west-wa-sea-2303

# wait for all jobs to finish
jobs

# force Flux to sync
KUBECONFIG=$HOME/.kube/central-la-nola-2301.yaml kic sync &
KUBECONFIG=$HOME/.kube/central-la-nola-2302.yaml kic sync &
KUBECONFIG=$HOME/.kube/central-tx-atx-2301.yaml kic sync &
KUBECONFIG=$HOME/.kube/central-tx-atx-2302.yaml kic sync &
KUBECONFIG=$HOME/.kube/east-ga-atl-2301.yaml kic sync &
KUBECONFIG=$HOME/.kube/east-ga-atl-2302.yaml kic sync &
KUBECONFIG=$HOME/.kube/east-nc-clt-2301.yaml kic sync &
KUBECONFIG=$HOME/.kube/east-nc-clt-2302.yaml kic sync &
KUBECONFIG=$HOME/.kube/west-ca-sd-2301.yaml kic sync &
KUBECONFIG=$HOME/.kube/west-ca-sd-2302.yaml kic sync &
KUBECONFIG=$HOME/.kube/west-wa-sea-2301.yaml kic sync &
KUBECONFIG=$HOME/.kube/west-wa-sea-2302.yaml kic sync &

KUBECONFIG=$HOME/.kube/central-la-nola-2303.yaml kic sync &
KUBECONFIG=$HOME/.kube/central-tx-atx-2303.yaml kic sync &
KUBECONFIG=$HOME/.kube/east-ga-atl-2303.yaml kic sync &
KUBECONFIG=$HOME/.kube/east-nc-clt-2303.yaml kic sync &
KUBECONFIG=$HOME/.kube/west-ca-sd-2303.yaml kic sync &
KUBECONFIG=$HOME/.kube/west-wa-sea-2303.yaml kic sync &

# check the pods on each cluster
kic pods | grep x-central-la-nola-2301
kic pods | grep x-central-la-nola-2302
kic pods | grep x-central-la-nola-2303
kic pods | grep x-central-tx-atx-2301
kic pods | grep x-central-tx-atx-2302
kic pods | grep x-central-tx-atx-2303
kic pods | grep x-east-ga-atl-2301
kic pods | grep x-east-ga-atl-2302
kic pods | grep x-east-ga-atl-2303
kic pods | grep x-east-nc-clt-2301
kic pods | grep x-east-nc-clt-2302
kic pods | grep x-east-nc-clt-2303
kic pods | grep x-west-ca-sd-2301
kic pods | grep x-west-ca-sd-2302
kic pods | grep x-west-ca-sd-2303
kic pods | grep x-west-wa-sea-2301
kic pods | grep x-west-wa-sea-2302
kic pods | grep x-west-wa-sea-2303

kic pods | grep x-central
kic pods | grep x-east
kic pods | grep x-west

# delete your fleet
vcluster delete central-la-nola-2301 &
vcluster delete central-tx-atx-2301 &
vcluster delete east-ga-atl-2301 &
vcluster delete east-nc-clt-2301 &
vcluster delete west-ca-sd-2301 &
vcluster delete west-wa-sea-2301

vcluster delete central-la-nola-2302 &
vcluster delete central-tx-atx-2302 &
vcluster delete east-ga-atl-2302 &
vcluster delete east-nc-clt-2302 &
vcluster delete west-ca-sd-2302 &
vcluster delete west-wa-sea-2302

vcluster delete central-la-nola-2303 &
vcluster delete central-tx-atx-2303 &
vcluster delete east-ga-atl-2303 &
vcluster delete east-nc-clt-2303 &
vcluster delete west-ca-sd-2303 &
vcluster delete west-wa-sea-2303

# wait for clusters to delete
kic pods --watch

```
