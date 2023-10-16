#!/bin/bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
source versions.sh

deps=(
    cmake
    g++
    libcurl4-openssl-dev
    libssh2-1-dev
    libssl-dev
    make
    patch
    pkg-config
    python-is-python3
    python3
    time
    zlib1g-dev
)

mkdir root
rsync -avP sources/ configs/ build.sh versions.sh root/build

pushd root/build
echo "Extracting mrustc ${mrustc_version}"
tar xzf "mrustc-${mrustc_version}.tar.gz"
ln -s "../rustc-${rustc_versions[0]}-src.tar.gz" "mrustc-${mrustc_version}"
for v in "${rustc_versions[@]:1}"; do
    echo "Extracting rustc $v"
    mkdir -p "rustc-$v"
    tar xzf "rustc-$v-src.tar.gz" -C "rustc-$v" --strip-components 1
done
popd

sudo chown root:root ./root
sudo debootstrap --include=$(IFS=,; echo "${deps[*]}") bullseye ./root

echo 'To enter the chroot:'
echo '$ firejail --chroot=./root --net=none --private-cwd=/build'
