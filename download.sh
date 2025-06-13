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
    checksum_path="rustc-$v-src.tar.gz.sha256"

    if [[ ! -e "${checksum_path}" ]]; then
        curl \
            -L "https://static.rust-lang.org/dist/${checksum_path}" \
            -o "${checksum_path}"
    fi

    expected_checksum="${rustc_checksum[$v]}  ${source_path}"
    remote_expected_checksum=$(cat rustc-$v-src.tar.gz.sha256)

    if [[ "${expected_checksum}" != "${remote_expected_checksum}" ]]; then
        echo 1>&2 "expected sha256 to be ${expected_checksum}, got ${remote_expected_checksum}"
        exit 1
    fi

    if [[ ! -e "${source_path}" ]]; then
        curl \
            -L "https://static.rust-lang.org/dist/${source_path}" \
            -o "${source_path}"
    fi

    sha256sum --check "$checksum_path"
done
