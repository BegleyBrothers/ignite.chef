#!/usr/bin/env bash
export CNI_VERSION=v0.8.2
export ARCH=$([ $(uname -m) = 'x86_64' ] && echo amd64 || echo arm64)
mkdir -p /opt/cni/bin
export cni_url=https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz
if command -v wget > /dev/null 2>&1
then
  wget -qO- ${cni_url} | tar -xz -C /opt/cni/bin
elif command -v curl > /dev/null 2>&1
then
  curl -sSL ${cni_url} | tar -xz -C /opt/cni/bin
else
  echo 'wget and curl not available'
fi
