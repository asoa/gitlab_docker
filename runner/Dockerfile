FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG AZURE_CLI_VERSION=2.57.0
ARG TERRAFORM_VERSION=1.7.3
ARG PACKER_VERSION=1.10.0
ARG POWERSHELL_VERSION=7.3.7
ARG DISTRO=jammy
ARG DISTRO_VERSION=22.04

# https://gitlab.com/gitlab-org/gitlab-runner/-/blob/main/dockerfiles/runner/ubuntu/Dockerfile
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        git git-lfs \
        wget \
        tzdata \
        openssh-client \
        apt-transport-https \
        lsb-release \
        gnupg \
        unzip \
        git \
    && rm -rf /var/lib/apt/lists/*

# install gitlab runner
RUN curl -L https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 -o /usr/local/bin/gitlab-runner && \
    chmod +x /usr/local/bin/gitlab-runner && \
    groupadd -g 1001 gitlab-runner && \
    useradd -g 1001 -u 1001 -m gitlab-runner -s /bin/bash 

# install azure cli
# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt#install-specific-version
RUN apt-get update && \
    apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg unzip git && \
    mkdir -p /etc/apt/keyrings && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/keyrings/microsoft.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/microsoft.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ ${DISTRO} main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install -y azure-cli=${AZURE_CLI_VERSION}-1~${DISTRO}

# install terraform and packer https://developer.hashicorp.com/terraform/install
RUN curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip -d /usr/local/bin && \
    rm terraform.zip && \
    curl -L https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -o packer.zip && \
    unzip packer.zip -d /usr/local/bin && \
    rm packer.zip

ADD main.tf /tmp/main.tf

# terraform init to download plugins
RUN mkdir -p /opt/terraform-init && \
    cp /tmp/main.tf /opt/terraform-init && \
    cd /opt/terraform-init && \
    terraform providers mirror . 

ADD plugins.pkr.hcl /tmp/plugins.pkr.hcl

# packer init to download plugins
RUN mkdir -p /opt/packer-init && \
    cp /tmp/plugins.pkr.hcl /opt/packer-init && \
    cd /opt/packer-init && \
    packer init .
    
# https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3
RUN apt-get update && \
    apt-get install -y curl apt-transport-https software-properties-common && \
    curl -sSfLO https://packages.microsoft.com/config/ubuntu/${DISTRO_VERSION}/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell && \
    # clean apt directories
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install docker
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin --yes && \
    # clean apt directories
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# install jq
ARG JQ_VERSION=1.7.1
RUN apt-get update && \
    apt-get install -y curl && \
    curl -SfLO https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-linux-amd64 && \
    chmod +x jq-linux-amd64 && \
    mv jq-linux-amd64 /usr/local/bin/jq