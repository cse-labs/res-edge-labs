#!/bin/bash

tag=$1

echo "installing kic $tag"

mkdir -p "$HOME/bin"

# update CLI
cd "$HOME/bin" || exit

# remove old CLI
rm -rf kic flt .kic .flt

# use latest release
if [ "$tag" = "" ]; then
    tag=$(curl -s https://api.github.com/repos/kubernetes101/pib-dev/releases/latest | grep tag_name | cut -d '"' -f4)
fi

# install kic
wget -O kic.tar.gz "https://github.com/kubernetes101/pib-dev/releases/download/$tag/kic-$tag-linux-amd64.tar.gz"
tar -xvzf kic.tar.gz
rm kic.tar.gz

cd "$OLDPWD" || exit
