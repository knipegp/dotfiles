cache_dir := ./.ansible/collections/ansible_collections/gknipe

all: podman controller

become:
	sudo -v

python: become
	sudo pacman -S --noconfirm --needed python

poetry: python
	poetry --version > /dev/null || curl -sSL https://install.python-poetry.org | python3 -
	poetry install --no-root
	pre-commit install

podman: become
	sudo pacman -S --noconfirm --needed podman buildah

controller: poetry
	mkdir -p $(cache_dir)
	ln -s gknipe/personal $(cache_dir)/personal

clean:
	rm -rf $(cache_dir)/personal

.PHONY: python poetry controller clean
