#!/bin/bash

# this runs as part of pre-build

echo "on-create start"
echo "$(date +'%Y-%m-%d %H:%M:%S')    on-create start" >> "$HOME/status"

# Change shell to zsh for vscode
sudo chsh --shell /bin/zsh vscode

# restore the project to avoid errors
dotnet restore labs/advanced-labs/cli/myapp/src

{
    echo ""

    #shellcheck disable=2016,2028
    echo 'hsort() { read -r; printf "%s\\n" "$REPLY"; sort }'
    echo ""

    # add cli to path
    echo "export PIB_BASE=$PWD"
    echo "export REPO_BASE=$PWD"
    echo "export MSSQL_SA_PASSWORD=Res-Edge23"
    echo ""

    echo "if [ -z $KIC_DATASERVICE_URL ]"
    echo "then"
    echo "    export KIC_DATASERVICE_URL=http://localhost:32080"
    echo "fi"
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

# configure git
git config --global core.whitespace blank-at-eol,blank-at-eof,space-before-tab
git config --global pull.rebase false
git config --global init.defaultbranch main
git config --global fetch.prune true
git config --global core.pager more
git config --global diff.colorMoved zebra
git config --global devcontainers-theme.show-dirty 1
git config --global core.editor "nano -w"

echo "dowloading kic and flt CLI"
.devcontainer/cli-update.sh

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
docker pull ghcr.io/cse-labs/res-edge-webv:0.8
docker pull ghcr.io/cse-labs/res-edge-automation:0.8

sudo apt-get update

# only run apt upgrade on pre-build
if [ "$CODESPACE_NAME" = "null" ]
then
    echo "$(date +'%Y-%m-%d %H:%M:%S')    upgrading" >> "$HOME/status"
    sudo apt-get upgrade -y
fi

echo "on-create complete"
echo "$(date +'%Y-%m-%d %H:%M:%S')    on-create complete" >> "$HOME/status"
