#!/bin/bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
source versions.sh

deps=(
    cmake
    g++
    libcurl4-openssl-dev
    libfindbin-libs-perl
    libssh2-1-dev
    libssl-dev
    make
    ninja-build
    patch
    pkg-config
    python3
    time
    zlib1g-dev
)

mkdir root
rsync -avP sources/ configs/ build.sh versions.sh root/build

pushd root/build
echo "Extracting mrustc ${mrustc_version}"
mkdir -p "mrustc-${mrustc_version}"
tar xzf "mrustc-${mrustc_version}.tar.gz" -C "mrustc-${mrustc_version}" --strip-components=1
ln -s "../rustc-${rustc_versions[0]}-src.tar.gz" "mrustc-${mrustc_version}"
for v in "${rustc_versions[@]:1}"; do
    echo "Extracting rustc $v"
    mkdir -p "rustc-$v"
    tar xzf "rustc-$v-src.tar.gz" -C "rustc-$v" --strip-components=1
done
popd

sudo chown root:root ./root
sudo chmod u+w,g-w,o-w ./root
sudo debootstrap --include=$(IFS=,; echo "${deps[*]}") trixie ./root

echo 'To enter the chroot:'
echo '$ firejail --chroot=./root --net=none --private-cwd=/build'
