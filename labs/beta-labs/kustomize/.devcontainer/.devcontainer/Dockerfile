# this image is built and updated weekly
# https://github.com/cse-labs/codespaces-images

FROM ghcr.io/cse-labs/k3d:latest

# some images require specific values
ARG USERNAME=vscode

ENV NVM_DIR=/usr/local/share/nvm

# update welcome message; chown home dir
RUN echo "$(date +'%Y-%m-%d %H:%M:%S')    docker build start" >> "/home/${USERNAME}/status" && \
    apt-get update && \
    mkdir -p "/home/${USERNAME}/.config/vscode-dev-containers" && \
    mkdir -p /usr/local/etc/vscode-dev-containers && \
    echo "👋 Welcome to BartR's Codespace!" > /usr/local/etc/vscode-dev-containers/first-run-notice.txt && \
    echo "" >> /usr/local/etc/vscode-dev-containers/first-run-notice.txt && \
    echo "cat /usr/local/etc/vscode-dev-containers/first-run-notice.txt" >> /etc/zsh/zshrc && \
    touch "/home/${USERNAME}/.config/vscode-dev-containers/first-run-notice-already-displayed" && \
    echo "" >> "/home/${USERNAME}/.bashrc" && \
    echo "export NVM_DIR=$NVM_DIR" >> "/home/${USERNAME}/.bashrc" && \
    echo "[ -s $NVM_DIR/nvm.sh ] && \. $NVM_DIR/nvm.sh" >> "/home/${USERNAME}/.bashrc" && \
    [ -s $NVM_DIR/nvm.sh ] && \. $NVM_DIR/nvm.sh && \
    nvm install 16 && \
    nvm use 16 && \
    npm install -g npm && \
    npm install -g @cadl-lang/compiler && \
    npm install -g @cadl-lang/rest @cadl-lang/openapi3 && \
    echo "$(date +'%Y-%m-%d %H:%M:%S')    docker build complete" >> "/home/${USERNAME}/status" && \
    chown -R ${USERNAME}:${USERNAME} "/home/${USERNAME}"
