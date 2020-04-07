#!/bin/bash

set -euo pipefail

source /build/versions.sh

cd "/build/rustc-${rustc_versions[0]}"
echo "Patching rustc-${rustc_versions[0]}"
patch -p0 <"../mrustc-${mrustc_version}/rustc-1.29.0-src.patch"

cd "/build/mrustc-${mrustc_version}"
export LIBSSH2_SYS_USE_PKG_CONFIG=true
export MINICARGO_FLAGS="-j$(nproc)"
echo "Building mrustc-${mrustc_version}"
make -j$(nproc) -f minicargo.mk bin/mrustc
echo "Building rustc-${rustc_versions[0]}"
make -j$(nproc) -f minicargo.mk RUSTCSRC="../rustc-${rustc_versions[0]}/" output/rustc
make -j$(nproc) -f minicargo.mk RUSTCSRC="../rustc-${rustc_versions[0]}/" output/cargo
cd "/build/mrustc-${mrustc_version}/run_rustc"
make -j$(nproc) RUST_SRC="../../rustc-${rustc_versions[0]}/src/"

export CARGO_HOME=/build/.cargo
unset SUDO_USER
for v in "${rustc_versions[@]:1}"; do
    cd "/build/rustc-$v"
    echo "Building rustc-$v"
    ./x.py build
done
