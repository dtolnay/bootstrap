#!/bin/bash

set -euo pipefail

. versions.sh

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
rsync -avP sources/ configs/ build.sh versions.sh root/build

cd root/build
echo "Extracting mrustc-${mrustc_version}"
tar xzf mrustc-${mrustc_version}.tar.gz
for v in ${mrustc_rustc_version} "${rustc_versions[@]}" ; do
    echo "Extracting rustc-$v"
    tar xzf rustc-$v-src.tar.gz -C rustc-$v --strip-components 1
done

sudo chown root:root ./root
sudo debootstrap --include=$(IFS=,; echo "${deps[*]}") stable ./root

echo 'To enter the chroot:'
echo '$ firejail --chroot=./root --net=none --private-cwd=/build'
