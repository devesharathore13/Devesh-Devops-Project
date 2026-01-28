FROM jenkins/inbound-agent:latest

USER root

RUN apt-get update && apt-get install -y \
    docker.io \
    kubectl \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz | tar xz && \
    mv linux-amd64/helm /usr/local/bin/

USER jenkins
