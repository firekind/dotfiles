#!/bin/bash

set -eo pipefail

if [[ -f /.firekindcontainersetupdone ]]; then
    exit 0
fi

# setting up home symlinks
ln -s /var/home/firekind/.ssh $HOME/.ssh
ln -s /var/home/firekind/Downloads $HOME/Downloads
rm -f ~/.zshrc && ln -s /var/home/firekind/.zshrc $HOME/.zshrc

# install oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh > /tmp/oh-my-zsh-install.sh
sh /tmp/oh-my-zsh-install.sh --unattended --keep-zshrc
rm /tmp/oh-my-zsh-install.sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# installing rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# installing bazelisk
curl -o /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v1.20.0/bazelisk-linux-amd64 
chmod +x /usr/local/bin/bazel

# fixing ownership of folders within of home directory, since this script ends up running as root
chown -R firekind:firekind $HOME

# installing clis
tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
dnf install -y 'dnf-command(config-manager)'
dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
dnf install -y google-cloud-cli awscli2
dnf install -y gh --repo gh-cli

# adding symlink for host's docker
ln -s /usr/bin/distrobox-host-exec /usr/local/bin/docker

touch /.firekindcontainersetupdone
