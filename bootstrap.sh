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
    local collection_install_path

    poetry=~/.local/bin/poetry
    "${poetry}" install --sync
    "${poetry}" run pre-commit install
    # "${poetry}" run ansible-galaxy collection install "$(dirname "${script_dir}")"/gknipe/personal
    collection_install_path="$(dirname "${script_dir}")"/.ansible/collections/ansible_collections/gknipe/personal
    mkdir -p "$(dirname "${collection_install_path}")"
    ln -s "$(dirname "${script_dir}")"/gknipe/personal "${collection_install_path}"
}

main() {
    install_poetry
    bootstrap_controller
}

main
