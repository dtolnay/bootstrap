#!/bin/bash

set -euo pipefail

source /build/versions.sh

cd "/build/rustc-${mrustc_rustc_version}"
echo "Patching rustc-${mrustc_rustc_version}"
patch -p0 <"../mrustc-${mrustc_version}/rustc-1.29.0-src.patch"

cd "/build/mrustc-${mrustc_version}"
export LIBSSH2_SYS_USE_PKG_CONFIG=true
export MINICARGO_FLAGS="-j$(nproc)"
echo "Building mrustc-${mrustc_version}"
make -j$(nproc) -f minicargo.mk bin/mrustc
echo "Building rustc-${mrustc_rustc_version}"
make -j$(nproc) -f minicargo.mk RUSTCSRC="../rustc-${mrustc_rustc_version}/" output/rustc
make -j$(nproc) -f minicargo.mk RUSTCSRC="../rustc-${mrustc_rustc_version}/" output/cargo
cd "/build/mrustc-${mrustc_version}/run_rustc"
make -j$(nproc) RUST_SRC="../../rustc-${mrustc_rustc_version}/src/"

export CARGO_HOME=/build/.cargo
unset SUDO_USER
for v in "${rustc_versions[@]}"; do
    cd "/build/rustc-$v"
    echo "Building rustc-$v"
    ./x.py build
done
