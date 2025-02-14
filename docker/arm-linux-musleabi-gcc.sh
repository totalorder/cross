#!/bin/bash

# this linker wrapper works around the missing sync `sync_X_and_fetch`
# routines. this affects rust versions with compiler-builtins <= 0.1.77,
# which affects toolchains older than 1.65 which require the `-lgcc`
# linker flag to provide the missing builtin.
# https://github.com/rust-lang/compiler-builtins/pull/484

set -x
set -euo pipefail

# shellcheck disable=SC1091
. /rustc_info.sh

main() {
    local minor
    minor=$(rustc_minor_version)

    if (( minor >= 65 )) || [[ $# -eq 0 ]]; then
        exec arm-linux-musleabi-gcc "${@}"
    else
        exec arm-linux-musleabi-gcc "${@}" -lgcc -static-libgcc
    fi
}

main "${@}"
