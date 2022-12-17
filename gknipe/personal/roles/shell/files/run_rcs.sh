#!/usr/bin/env bash

function run_custom_rcs() {
    local profile
    local rcd

    rcd="${HOME}"/.bashrc.d

    if test -d "${rcd}"; then
        for profile in "${rcd}"/*.sh; do
            # shellcheck source=/dev/null
            test -r "${profile}" && . "${profile}"
        done
    fi
}

run_custom_rcs
