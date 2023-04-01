#!/bin/zsh

# this runs as part of pre-build

echo "on-create start"
echo "$(date +'%Y-%m-%d %H:%M:%S')    on-create start" >> "$HOME/status"

# Change shell to zsh for vscode
sudo chsh --shell /bin/zsh vscode

export PATH="$PATH:$HOME/bin:$PWD/bin"

mkdir -p "$HOME/.ssh"
mkdir -p "$HOME/bin"
mkdir -p "$HOME/.oh-my-zsh/completions"

{
    echo ""

    # add cli to path
    echo "export PATH=\$PATH:$HOME/bin:$PWD/bin"
    echo "export REPO_BASE=$PWD"
    echo ""

    echo "compinit"
} >> "$HOME/.zshrc"

echo "dowloading kic and flt CLI"
.devcontainer/cli-update.sh

# install kustomize
cd /usr/local/bin || exit
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | sudo bash

echo "generating completions"
kic completion zsh > "$HOME/.oh-my-zsh/completions/_kic"
kubectl completion zsh > "$HOME/.oh-my-zsh/completions/_kubectl"
kustomize completion zsh > "$HOME/.oh-my-zsh/completions/_kustomize"

# run dotnet restore on the apps
# only run apt upgrade on pre-build
if [ "$CODESPACE_NAME" = "null" ]
then
    echo "$(date +'%Y-%m-%d %H:%M:%S')    upgrading" >> "$HOME/status"
    sudo apt-get update
    sudo apt-get upgrade -y
fi

echo "on-create complete"
echo "$(date +'%Y-%m-%d %H:%M:%S')    on-create complete" >> "$HOME/status"
