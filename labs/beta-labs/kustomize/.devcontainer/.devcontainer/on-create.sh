#!/bin/zsh

# this runs as part of pre-build

echo "on-create start"
echo "$(date +'%Y-%m-%d %H:%M:%S')    on-create start" >> "$HOME/status"

# Change shell to zsh for vscode
sudo chsh --shell /bin/zsh vscode

export MSSQL_SA_PASSWORD=Res-Edge23
export PATH="$PATH:$HOME/bin:/opt/mssql-tools/bin"
export GOPATH="$HOME/go"

mkdir -p "$HOME/.ssh"
mkdir -p "$HOME/.oh-my-zsh/completions"

export PIB_MI=/subscriptions/8bec903d-0c37-4366-8604-70055f04b4cf/resourcegroups/TLD/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pib-mi
export PIB_SSL=k8s-edge.com
export PIB_DNS_RG=tld
export PIB_KEYVAULT=kv-pib
export PIB_GHCR=ghcr.io/cse-labs

{
    echo ""

    #shellcheck disable=2016,2028
    echo 'hsort() { read -r; printf "%s\\n" "$REPLY"; sort }'
    echo ""

    echo "export MSSQL_SA_PASSWORD=$MSSQL_SA_PASSWORD"
    echo ""

    # add cli to path
    echo "export PATH=\$PATH:$HOME/bin:/opt/mssql-tools/bin"
    echo "export GOPATH=\$HOME/go"
    echo "export REPO_BASE=$PWD"
    echo "export SQL_CONN_STRING='Data Source=localhost;Initial Catalog=ist; UID=sa; PWD=$MSSQL_SA_PASSWORD; TrustServerCertificate=True;'"
    echo ""

    echo "export GITHUB_TOKEN=\$PAT"
    echo ""

    echo "export MY_BRANCH=\$(echo \$GITHUB_USER | tr '[:upper:]' '[:lower:]')"
    echo ""

    echo "export PIB_MI=$PIB_MI"
    echo "export PIB_SSL=$PIB_SSL"
    echo "export PIB_DNS_RG=$PIB_DNS_RG"
    echo "export PIB_KEYVAULT=$PIB_KEYVAULT"
    echo "export PIB_GHCR=$PIB_GHCR"
    echo ""

    echo "alias dlogin='docker login ghcr.io -u bartr -p \$PAT'"
    echo ""

    echo "compinit"
} >> "$HOME/.zshrc"

mkdir -p $HOME/bin
# create sql script
{
    echo "#!/bin/bash"
    echo ""
    echo 'sqlcmd -d ist -S localhost -U sa -P $MSSQL_SA_PASSWORD "$@"'
} > $HOME/bin/sql
chmod +x $HOME/bin/sql

echo "installing Go modules"
go install -v github.com/spf13/cobra/cobra@latest
go install -v golang.org/x/lint/golint@latest
go install -v github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
go install -v github.com/ramya-rao-a/go-outline@latest
go install -v github.com/cweill/gotests/gotests@latest
go install -v github.com/fatih/gomodifytags@latest
go install -v github.com/josharian/impl@latest
go install -v github.com/haya14busa/goplay/cmd/goplay@latest
go install -v github.com/go-delve/delve/cmd/dlv@latest
go install -v honnef.co/go/tools/cmd/staticcheck@latest
go install -v golang.org/x/tools/gopls@latest

echo "dowloading kic and flt CLI"
.devcontainer/cli-update.sh

# can remove once incorporated in base image
echo "Updating k3d to 5.4.6"
wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=v5.4.6 bash

# install kustomize
cd /usr/local/bin || exit
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | sudo bash

# install sqlcmd
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt-get update
sudo ACCEPT_EULA=y apt-get install -y mssql-tools unixodbc-dev

# install dotnet coverage tool
dotnet tool install --global dotnet-reportgenerator-globaltool

echo "generating completions"
kic completion zsh > "$HOME/.oh-my-zsh/completions/_kic"
flt completion zsh > "$HOME/.oh-my-zsh/completions/_flt"
gh completion -s zsh > ~/.oh-my-zsh/completions/_gh
kubectl completion zsh > "$HOME/.oh-my-zsh/completions/_kubectl"
k3d completion zsh > "$HOME/.oh-my-zsh/completions/_k3d"
kustomize completion zsh > "$HOME/.oh-my-zsh/completions/_kustomize"
gh completion -s zsh > "$HOME/.oh-my-zsh/completions/_gh"

echo "Pulling docker images"
docker pull mcr.microsoft.com/dotnet/sdk:7.0
docker pull mcr.microsoft.com/dotnet/aspnet:7.0-alpine
docker pull mcr.microsoft.com/mssql/server:2022-latest

echo "start SQL Server in container"
docker run \
    -e "ACCEPT_EULA=Y" \
    -e "MSSQL_SA_PASSWORD=$MSSQL_SA_PASSWORD" \
    -p 1433:1433 \
    --name mssql \
    --hostname mssql \
    --restart always \
    -d \
    mcr.microsoft.com/mssql/server:2022-latest

echo "create local registry"
docker network create k3d
k3d registry create registry.localhost --port 5500
docker network connect k3d k3d-registry.localhost

echo "kic cluster create"
kic cluster create

# create ist database
sqlcmd -S localhost -U sa -P $MSSQL_SA_PASSWORD -Q "create database ist;"

# run dotnet restore on the apps
# only run apt upgrade on pre-build
if [ "$CODESPACE_NAME" = "null" ]
then
    echo "$(date +'%Y-%m-%d %H:%M:%S')    upgrading" >> "$HOME/status"
    sudo apt-get update
    sudo apt-get upgrade -y
fi

# install dotnet 6
sudo apt-get install -y dotnet-sdk-6.0 dotnet-sdk-3.1

echo "on-create complete"
echo "$(date +'%Y-%m-%d %H:%M:%S')    on-create complete" >> "$HOME/status"

echo "create local registry"
docker network create k3d
k3d registry create registry.localhost --port 5500
docker network connect k3d k3d-registry.localhost

# echo "kic cluster create"
# kic cluster create

# only run apt upgrade on pre-build
if [ "$CODESPACE_NAME" = "null" ]
then
    echo "$(date +'%Y-%m-%d %H:%M:%S')    upgrading" >> "$HOME/status"
    sudo apt-get update
    sudo apt-get upgrade -y
fi

echo "on-create complete"
echo "$(date +'%Y-%m-%d %H:%M:%S')    on-create complete" >> "$HOME/status"
