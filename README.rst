=================
G's System Config
=================

Use NixOS to organize personal system configuration.

Boot-strapping steps.

#. Create new directory in ``hosts``
#. Create a new ``flake.nix`` in that directory
#. Ensure ``hosts/home.nix`` sources desired modules
#. Copy ``/etc/nixos/hardware-configuration.nix`` to that directory

.. code-block:: bash

    sudo nixos-rebuild switch --flake <dotfiles-path>/nixos/#<hostname>

.. code-block:: bash

    nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    home-manager -v switch -b backup --flake <dotfiles-path>/nixos/home-manager/
