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
vcluster create central-la-nola-2301 --connect=false
vcluster create central-tx-atx-2301 --connect=false
vcluster create east-ga-atl-2301 --connect=false
vcluster create east-nc-clt-2301 --connect=false
vcluster create west-ca-sd-2301 --connect=false
vcluster create west-wa-sea-2301 --connect=false

# wait for pods
kic pods --watch

# deploy flux
./vflux.sh central-la-nola-2301
./vflux.sh central-tx-atx-2301
./vflux.sh east-ga-atl-2301
./vflux.sh east-nc-clt-2301
./vflux.sh west-ca-sd-2301
./vflux.sh west-wa-sea-2301

# connect to a cluster
# this runs port forwarding in the background
# kubectl config is updated to the vCluster
vcluster connect central-la-nola-2301 &

# run kic
kic pods
kic sync

# disconnect from vCluster
vcluster disconnect

# delete your fleet
vcluster delete central-la-nola-2301
vcluster delete central-tx-atx-2301
vcluster delete east-ga-atl-2301
vcluster delete east-nc-clt-2301
vcluster delete west-ca-sd-2301
vcluster delete west-wa-sea-2301

```
