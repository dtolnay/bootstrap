#!/bin/bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
mkdir -p sources
cd sources

curl -L https://github.com/thepowersgang/mrustc/archive/v0.9.tar.gz | tar xz

versions=(
    1.29.2
    1.30.0
    1.31.1
    1.32.0
    1.33.0
    1.34.2
    1.35.0
    1.36.0
    1.37.0
    1.38.0
    1.39.0
    1.40.0
    1.41.0
)

for v in "${versions[@]}"; do
    mkdir rustc-$v
    curl -L https://static.rust-lang.org/dist/rustc-$v-src.tar.gz \
        | tar xz -C rustc-$v --strip-components 1
done
