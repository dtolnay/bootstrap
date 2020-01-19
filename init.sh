#!/bin/bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

deps=(
    cmake
    g++
    libcurl4-openssl-dev
    libssh2-1-dev
    libssl-dev
    make
    patch
    pkg-config
    python
    time
    zlib1g-dev
)

mkdir root
rsync -a sources/ configs/ build.sh root/build
sudo chown root:root ./root
sudo debootstrap --include=$(IFS=,; echo "${deps[*]}") stable ./root

echo 'To enter the chroot:'
echo '$ firejail --chroot=./root --net=none --private-cwd=/build'
