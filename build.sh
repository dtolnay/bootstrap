#!/bin/bash

set -euo pipefail

cd /build/rustc-1.29.2
patch -p0 <../mrustc-0.9/rustc-1.29.0-src.patch

cd /build/mrustc-0.9
export LIBSSH2_SYS_USE_PKG_CONFIG=true
make -j$(nproc) -f minicargo.mk bin/mrustc
make -j$(nproc) -f minicargo.mk RUSTCSRC=../rustc-1.29.2/ output/rustc output/cargo
cd /build/mrustc-0.9/run_rustc
make -j$(nproc) RUST_SRC=../../rustc-1.29.2/src/

export CARGO_HOME=/build/.cargo
cd /build/rustc-1.30.0 && ./x.py build
cd /build/rustc-1.31.1 && ./x.py build
cd /build/rustc-1.32.0 && ./x.py build
cd /build/rustc-1.33.0 && ./x.py build
cd /build/rustc-1.34.2 && ./x.py build
cd /build/rustc-1.35.0 && ./x.py build
cd /build/rustc-1.36.0 && ./x.py build
cd /build/rustc-1.37.0 && ./x.py build
cd /build/rustc-1.38.0 && ./x.py build
cd /build/rustc-1.39.0 && ./x.py build
cd /build/rustc-1.40.0 && ./x.py build
cd /build/rustc-1.41.0 && ./x.py build
