#!/bin/bash

# this runs as part of pre-build

echo "on-create start"
echo "$(date +'%Y-%m-%d %H:%M:%S')    on-create start" >> "$HOME/status"

# Change shell to zsh for vscode
sudo chsh --shell /bin/zsh vscode

export GOPATH="$HOME/go"
export PATH="$PATH:$HOME/bin:/opt/mssql-tools/bin"

# restore the file to avoid errors
dotnet restore labs/advanced-labs/cli/myapp/src

mkdir -p "$HOME/bin"
mkdir -p "$HOME/.ssh"
mkdir -p "$HOME/.oh-my-zsh/completions"

{
    echo ""

    #shellcheck disable=2016,2028
    echo 'hsort() { read -r; printf "%s\\n" "$REPLY"; sort }'
    echo ""

    # add cli to path
    echo "export GOPATH=\$HOME/go"
    echo "export PIB_BASE=$PWD"
    echo "export PATH=\$PATH:$HOME/bin:/opt/mssql-tools/bin"
    echo "export MSSQL_SA_PASSWORD=Res-Edge23"
    echo ""

    echo "if [ \"\$PIB_PAT\" != \"\" ]"
    echo "then"
    echo "    export GITHUB_TOKEN=\$PIB_PAT"
    echo "fi"
    echo ""

    echo "if [ \"\$PAT\" != \"\" ]"
    echo "then"
    echo "    export GITHUB_TOKEN=\$PAT"
    echo "fi"
    echo ""

    echo "export PIB_PAT=\$GITHUB_TOKEN"
    echo "export PAT=\$GITHUB_TOKEN"
    echo ""

    echo "export MY_BRANCH=\$(echo \$GITHUB_USER | tr '[:upper:]' '[:lower:]')"
    echo ""

    echo "compinit"
} >> "$HOME/.zshrc"

{
    echo "defaultIPs: $PWD/ips"
    echo "reservedClusterPrefixes:"
    echo "  - corp-monitoring"
    echo "  - central-mo-kc"
    echo "  - central-tx-austin"
    echo "  - east-ga-atlanta"
    echo "  - east-nc-raleigh"
    echo "  - west-ca-sd"
    echo "  - west-wa-redmond"
    echo "  - west-wa-seattle"
} > "$HOME/.flt"

# create sql helper command
{
    echo '#!/bin/zsh'
    echo ""
    echo '/opt/mssql-tools/bin/sqlcmd -d ist -S localhost,31433 -U sa -P $MSSQL_SA_PASSWORD "$@"'
} > "$HOME/bin/sql"
chmod +x "$HOME/bin/sql"

echo "dowloading kic and flt CLI"
.devcontainer/cli-update.sh

echo "dowloading sqlcmd"
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt-get update
sudo ACCEPT_EULA=y apt-get install -y mssql-tools unixodbc-dev

echo "downloading kustomize"
pushd /usr/local/bin || exit
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | sudo bash
popd || exit

# can remove once incorporated in base image
echo "Updating k3d to 5.4.6"
wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=v5.4.6 bash

echo "generating completions"
kic completion zsh > "$HOME/.oh-my-zsh/completions/_kic"
flt completion zsh > "$HOME/.oh-my-zsh/completions/_flt"
gh completion -s zsh > ~/.oh-my-zsh/completions/_gh
kubectl completion zsh > "$HOME/.oh-my-zsh/completions/_kubectl"
k3d completion zsh > "$HOME/.oh-my-zsh/completions/_k3d"
kustomize completion zsh > "$HOME/.oh-my-zsh/completions/_kustomize"

echo "installing dotnet 6"
sudo apt-get install -y dotnet-sdk-6.0

echo "create local registry"
docker network create k3d
k3d registry create registry.localhost --port 5500
docker network connect k3d k3d-registry.localhost

echo "kic cluster create"
kic cluster create

echo "Pulling docker images"
docker pull mcr.microsoft.com/dotnet/sdk:6.0
docker pull mcr.microsoft.com/dotnet/aspnet:6.0-alpine
docker pull ghcr.io/cse-labs/pib-webv:latest

# todo - pull res-edge images

# only run apt upgrade on pre-build
if [ "$CODESPACE_NAME" = "null" ]
then
    echo "$(date +'%Y-%m-%d %H:%M:%S')    upgrading" >> "$HOME/status"
    sudo apt-get update
    sudo apt-get upgrade -y
fi

echo "on-create complete"
echo "$(date +'%Y-%m-%d %H:%M:%S')    on-create complete" >> "$HOME/status"
