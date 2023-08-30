#!/usr/bin/env bash

run_emacsclient() {
    emacsclient -n "$@"
}

if command -v emacsclient >/dev/null; then
    alias ec=run_emacsclient
fi

if [ -d "${HOME}/.config/emacs/bin" ]; then
    # shellcheck disable=SC1091
    export PATH="${PATH}":"${HOME}/.config/emacs/bin"
fi
