# Virtual Cluster Spike

> Work in Progress

## Setup

- Create a 16 core Codespace
- Checkout this branch
- Create your branch
- Rebuild your Codespace

```bash

# start in this directory
cd "$KIC_BASE/vfleet"

```

```bash

# deploy Res-Edge Data Service
"$KIC_BASE/.devcontainer/deploy-res-edge.sh"

# wait for pods
kic pods --watch

# check data service
ds list applications
ds list groups

```

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

# update Flux source to your repo / branch
code "$KIC_BASE/apps/flux-system/source.yaml"

# update data service
ds update-gitops

# run cicd and deploy (if needed)
ds cicd
ds deploy

```

```bash

# create your virtual fleet
# set the NodePort to 32100 + cluster ID
# on a 16 core CS, you can create 12 clusters, maybe 14
./create.sh 32101 central-la-nola-2301 &
./create.sh 32104 central-tx-atx-2301 &
./create.sh 32107 east-ga-atl-2301 &
./create.sh 32110 east-nc-clt-2301 &
./create.sh 32113 west-ca-sd-2301 &
./create.sh 32116 west-wa-sea-2301 &
./create.sh 32102 central-la-nola-2302 &
./create.sh 32105 central-tx-atx-2302 &
./create.sh 32108 east-ga-atl-2302 &
./create.sh 32111 east-nc-clt-2302 &
./create.sh 32114 west-ca-sd-2302 &
./create.sh 32117 west-wa-sea-2302

# ./create.sh 32103 central-la-nola-2303 &
# ./create.sh 32106 central-tx-atx-2303 &
# ./create.sh 32109 east-ga-atl-2303 &
# ./create.sh 32112 east-nc-clt-2303 &
# ./create.sh 32115 west-ca-sd-2303 &
# ./create.sh 32118 west-wa-sea-2303

# wait for pods
kic pods --watch

# list virtual clusters
vcluster list

```

```bash

# deploy flux
./vflux.sh central-la-nola-2301 &
./vflux.sh central-tx-atx-2301 &
./vflux.sh east-ga-atl-2301 &
./vflux.sh east-nc-clt-2301 &
./vflux.sh west-ca-sd-2301 &
./vflux.sh west-wa-sea-2301 &
./vflux.sh central-la-nola-2302 &
./vflux.sh central-tx-atx-2302 &
./vflux.sh east-ga-atl-2302 &
./vflux.sh east-nc-clt-2302 &
./vflux.sh west-ca-sd-2302 &
./vflux.sh west-wa-sea-2302

# ./vflux.sh central-la-nola-2303 &
# ./vflux.sh central-tx-atx-2303 &
# ./vflux.sh east-ga-atl-2303 &
# ./vflux.sh east-nc-clt-2303 &
# ./vflux.sh west-ca-sd-2303 &
# ./vflux.sh west-wa-sea-2303

# wait for all jobs to finish
jobs

# force Flux to sync
flt sync

# check the pods on each cluster
flt check flux
flt check heartbeat
flt check redis

```

```bash

# list applications from the data service
ds list applications

# deploy dogs-cats and tabs-spaces
ds set-expression --id 4 --expression /g/stores/central/tx
ds set-expression --id 5 --expression /g/stores/west/wa

# run cicd and deploy
ds cicd
ds deploy

# force Flux to sync
flt sync

# check apps
flt check dogs-cats
flt check tabs-spaces

```

```bash

# undeploy dogs-cats and tabs-spaces
ds set-expression --id 4 --expression null
ds set-expression --id 5 --expression null

# run cicd and deploy
ds cicd
ds deploy

# force Flux to sync
flt sync

# check apps
flt check dogs-cats
flt check tabs-spaces

```

```bash

# delete your fleet
vcluster delete central-la-nola-2301 &
vcluster delete central-tx-atx-2301 &
vcluster delete east-ga-atl-2301 &
vcluster delete east-nc-clt-2301 &
vcluster delete west-ca-sd-2301 &
vcluster delete west-wa-sea-2301 &
vcluster delete central-la-nola-2302 &
vcluster delete central-tx-atx-2302 &
vcluster delete east-ga-atl-2302 &
vcluster delete east-nc-clt-2302 &
vcluster delete west-ca-sd-2302 &
vcluster delete west-wa-sea-2302

# vcluster delete central-la-nola-2303 &
# vcluster delete central-tx-atx-2303 &
# vcluster delete east-ga-atl-2303 &
# vcluster delete east-nc-clt-2303 &
# vcluster delete west-ca-sd-2303 &
# vcluster delete west-wa-sea-2303

# wait for clusters to delete
kic pods --watch

```
