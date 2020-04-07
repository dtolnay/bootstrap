#!/bin/bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
source versions.sh
mkdir -p sources
cd sources

echo "Downloading mrustc-${mrustc_version}"
curl -L https://github.com/thepowersgang/mrustc/archive/v${mrustc_version}.tar.gz -o mrustc-${mrustc_version}.tar.gz

for v in ${mrustc_rustc_version} "${rustc_versions[@]}"; do
    echo "Downloading rustc-$v"
    curl -L https://static.rust-lang.org/dist/rustc-$v-src.tar.gz -o rustc-$v-src.tar.gz
done
