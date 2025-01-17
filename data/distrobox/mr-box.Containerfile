FROM ubuntu:22.04

ARG BAZELISK_VERSION=1.22.1
ARG BAZEL_BUILD_TOOLS_VERSION=7.3.1

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# repo setup stuff
RUN apt update && apt install -y --no-install-recommends curl apt-transport-https gpg ca-certificates

# gcloud cli repo setup
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# gh cli repo setup
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# docker repo setup
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu jammy stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# install packages
RUN apt update && apt install -y --no-install-recommends \
    zsh \
    git \
    vim \
    bat \
    wget \
    google-cloud-cli \
    gh \
    unzip \
    pre-commit \
    file \
    patch \
    ssh \
    python3-botocore \
    python3-google-auth \
    python3-requests \
    libtinfo5 \
    libstd-rust-1.77 \
    rustfmt-1.77 \
    libx11-6 \
    libxrender1 \
    libxxf86vm1 \
    libxfixes3 \
    libxi6 \
    libxkbcommon0 \
    libgomp1 \
    docker-ce-cli \
    docker-compose-plugin \
    docker-buildx-plugin \
    openssh-server

# configuring ssh server port
RUN echo "Port 23" >> /etc/ssh/sshd_config

# eza
RUN curl -fsSL https://github.com/eza-community/eza/releases/download/v0.20.4/eza_x86_64-unknown-linux-gnu.tar.gz | tar -xz -C /usr/local/bin

# aws cli
RUN curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip && \
    cd /tmp && unzip awscliv2.zip && \
    cd /tmp && ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update && \
    rm -rf /tmp/awscliv2.zip /tmp/aws

# bazel, buildifier, buildozer
RUN curl -fsSL -o /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VERSION}/bazelisk-linux-amd64 && \
    curl -fsSL -o /usr/local/bin/buildifier https://github.com/bazelbuild/buildtools/releases/download/v${BAZEL_BUILD_TOOLS_VERSION}/buildifier-linux-amd64 && \
    curl -fsSL -o /usr/local/bin/buildozer https://github.com/bazelbuild/buildtools/releases/download/v${BAZEL_BUILD_TOOLS_VERSION}/buildozer-linux-amd64 && \
    chmod +x /usr/local/bin/bazel /usr/local/bin/buildifier /usr/local/bin/buildozer
