all: python poetry podman

become:
	sudo -v

python: become
	sudo pacman -S --noconfirm --needed python

poetry: python
	poetry --version > /dev/null || curl -sSL https://install.python-poetry.org | python3 -
	poetry install --no-root
	pre-commit install

podman:
	sudo pacman -S --noconfirm --needed podman

.PHONY: python poetry
