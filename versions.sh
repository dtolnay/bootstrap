mrustc_version=0.12.0
declare -A rustc_checksum
rustc_checksum[1.90.0]=799a9f9cba4ed5351e071048bcf6b5560755d9009648def33a407dd4961f9b7e
rustc_checksum[1.91.1]=38dce205d39f61571261f0444237a1ce9efecb970e760d8ec4d957af5b445723
rustc_checksum[1.92.0]=9e0d2ca75c7e275fdc758255bf4b03afb3d65d1543602746907c933b6901c3b8
rustc_checksum[1.93.1]=4c230a44b3d9c9f3cef950943719f8380058d27c91fda5e36a9a947ef013e01f
rustc_versions=($(printf "%s\n" "${!rustc_checksum[@]}" | sort -V))
