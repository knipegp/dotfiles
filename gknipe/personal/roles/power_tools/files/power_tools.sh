#!/usr/bin/env bash

if [ -d "${HOME}/.local/bin" ]; then
    # shellcheck disable=SC1091
    export PATH="${PATH}":"${HOME}"/.local/bin
fi

# From: https://wiki.archlinux.org/title/SSH_keys#SSH_agents
if ! pgrep -u "${USER}" ssh-agent >/dev/null; then
    ssh-agent -t 4h >"${XDG_RUNTIME_DIR}/ssh-agent.env"
fi

# shellcheck source=/dev/null
source "${XDG_RUNTIME_DIR}/ssh-agent.env" >/dev/null

if [[ ! "${GPG_TTY}" ]]; then
    GPG_TTY="$(tty)"
    export GPG_TTY
fi

eval "$(starship init bash)"
