#!/usr/bin/env bash
export CNI_VERSION=v0.8.2
export ARCH=$([ $(uname -m) = 'x86_64' ] && echo amd64 || echo arm64)
mkdir -p /opt/cni/bin
curl -sSL https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz | tar -xz -C /opt/cni/bin
