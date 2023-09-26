#!/usr/bin/env bash

# User specific environment
if [[ "$PATH" =~ ${HOME}/.local/bin && -d "${HOME}/.local/bin" ]]; then
    # shellcheck disable=SC1091
    PATH="${PATH}":"${HOME}"/.local/bin
fi
export PATH

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

function git-clean-branches() {
    git branch --merged |
        grep -Ev "(^\*|master|main|dev)" |
        xargs -r git branch -d
    git remote prune origin
}
