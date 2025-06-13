#!/bin/bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
source versions.sh
mkdir -p sources
cd sources

echo "Downloading mrustc ${mrustc_version}"
if [[ ! -e "mrustc-${mrustc_version}.tar.gz" ]]; then
    curl \
        -L "https://github.com/thepowersgang/mrustc/archive/${mrustc_commit_override:-v${mrustc_version}}.tar.gz" \
        -o "mrustc-${mrustc_version}.tar.gz"
fi

for v in "${rustc_versions[@]}"; do
    echo "Downloading rustc $v"

    source_path="rustc-$v-src.tar.gz"
    hash_path="rustc-$v-src.tar.gz.sha256"

    if [[ ! -e "${hash_path}" ]]; then
        curl \
            -L "https://static.rust-lang.org/dist/${hash_path}" \
            -o "${hash_path}"
    fi

    expected_hash="${rust_version_hashes[$v]}"
    remote_expected_hash=$(cat rustc-$v-src.tar.gz.sha256)

    if [[ "${expected_hash}" != "${remote_expected_hash}" ]]; then
        echo 1>&2 "expected hash to be ${expected_hash}, got ${remote_expected_hash}"
        exit 1
    fi

    if [[ ! -e "${source_path}" ]]; then
        curl \
            -L "https://static.rust-lang.org/dist/${source_path}" \
            -o "${source_path}"
    fi

    sha256sum --check "$hash_path"
done
