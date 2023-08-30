#!/bin/bash

set -euo pipefail

script_dir="$(realpath "$0")"

install_poetry() {
    if ! type poetry >/dev/null; then
        curl -sSL https://install.python-poetry.org | python3 -
    fi
    echo Poetry "$(poetry -V)" is installed
}

bootstrap_controller() {
    local poetry

    poetry=~/.local/bin/poetry
    "${poetry}" install --sync
    "${poetry}" run pre-commit install
    "${poetry}" run ansible-galaxy collection install "$(dirname "${script_dir}")"/gknipe/personal
}

main() {
    install_poetry
    bootstrap_controller
}

main
