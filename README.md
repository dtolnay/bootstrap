Bootstrapping rustc from source
===============================

This repo contains a minimal reliable setup for compiling the most recent stable
Rust compiler from source on Linux i.e. without downloading any already compiled
Rust binaries from the internet.

The reason this is not straightforward is that the Rust compiler is written in
Rust; the ordinary way to compile it involves downloading an older Rust compiler
from the internet to build with.

This setup uses [mrustc] which is an alternative Rust compiler implemented in
C++ able to compile certain old versions of rustc and cargo, running in a Debian
chroot to achieve a consistent environment across host systems and [firejail] to
lock down accidental network accesses during the build.

<br>

## Motivation

The hope is that once the reproducibility of the Rust compiler is in better
shape ([rust-lang/rust#34902]) we can get this bootstrap chain to converge with
the chain that underlies the official rustc releases. At that point we would
have a way to verify no funny business in the official binary releases by
comparing hashes against another chain.

Further, we could establish independent bootstrap chains at some number of
reputable organizations (Google, Microsoft, Facebook, Amazon, ...) running in
environments that are trusted by each of those organizations. After every
release of Rust, those organizations could publish an attestation that the
compiler resulting from their independent bootstrap chain matches the hash of
the official release. With a diverse enough set of secure environments
confirming the hash, users can feel 100% confident downloading and using the
official release even in use cases where such a thing would ordinarily not be
acceptable.

<br>

## Steps

1. Install dependencies: [debootstrap] and [firejail].
2. Clone this repo.
3. Run `./download.sh` to download mrustc and all rustc sources required for the
   bootstrap chain.
4. Run `./init.sh` to initialize a chroot environment with the necessary
   dependencies for the bootstrap.
5. Run `firejail --chroot=./root --net=none --private-cwd=/build` to enter the
   chroot with networking blocked.
6. Run `./build.sh` from inside the chroot to kick off the bootstrap.

<br>

## Notes

Be aware that the complete bootstrap uses a lot of disk space. Bootstrapping up
through rustc 1.40 requires 120 GB.

<br>

## License

All intellectual property in this repository is licensed under the [Creative
Commons Attribution-ShareAlike 4.0 International License](LICENSE-CC-BY-SA).


[mrustc]: https://github.com/thepowersgang/mrustc
[firejail]: https://github.com/netblue30/firejail
[debootstrap]: https://wiki.debian.org/Debootstrap
[rust-lang/rust#34902]: https://github.com/rust-lang/rust/issues/34902
