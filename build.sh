#!/bin/bash

set -euo pipefail

source /build/versions.sh

cd "/build/mrustc-${mrustc_version}"
export LIBSSH2_SYS_USE_PKG_CONFIG=true
export PARLEVEL="$(nproc)"
export RUSTC_VERSION="${rustc_versions[0]}"
echo "Building mrustc ${mrustc_version}"
make -j$(nproc) -f minicargo.mk bin/mrustc
echo "Building rustc ${rustc_versions[0]}"
make -j$(nproc) -f minicargo.mk RUSTCSRC
make -j$(nproc) -f minicargo.mk "output-${rustc_versions[0]}/rustc"
make -j$(nproc) -f minicargo.mk "output-${rustc_versions[0]}/cargo"
cd "/build/mrustc-${mrustc_version}/run_rustc"
make -j$(nproc)

export CARGO_HOME=/build/.cargo
unset SUDO_USER
for v in "${rustc_versions[@]:1}"; do
    cd "/build/rustc-$v"
    echo "Building rustc $v"
    ./x.py build
done
