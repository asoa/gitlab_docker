FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG AZURE_CLI_VERSION=2.53.0
ARG TERRAFORM_VERSION=1.3.2
ARG PACKER_VERSION=1.8.1
ARG POWERSHELL_VERSION=7.3.7
ARG DISTRO=jammy
ARG DISTRO_VERSION=22.04

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

# install gitlab runner
RUN apt-get install -y curl && \
    curl -L https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 -o /usr/local/bin/gitlab-runner && \
    chmod +x /usr/local/bin/gitlab-runner && \
    # clean apt directories
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install terraform and packer
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
    apt-get install -y wget apt-transport-https software-properties-common && \
    curl -sSfLO https://packages.microsoft.com/config/ubuntu/${DISTRO_VERSION}/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell && \
    # clean apt directories
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
