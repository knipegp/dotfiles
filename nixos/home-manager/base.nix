{ config, pkgs, services, ... }:

{
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    udiskie
    # Basic terminal tools
    tealdeer
    eza
    ripgrep
    bottom
    du-dust
    sd
    procs
    fd
    bat
    nnn
    neofetch

    # Fonts
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" ]; })

    # Dev tools
    tokei
    gnupg

    # Emacs
    python312
    poetry
    black

    pandoc

    shellcheck
    shfmt

    graphviz

    nixfmt-classic

    rstfmt
    ##
  ];
  # Personal tools
  services.syncthing.enable = true;
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "always";
  };

  programs.git = {
    enable = true;
    userName = "Griffin Knipe";
    userEmail = "knipegp@gmail.com";
    difftastic.enable = true;
    extraConfig = { core.editor = "nvim"; };
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      run_emacsclient() {
          emacsclient -n "$@"
      }

      if command -v emacsclient >/dev/null; then
          alias ec=run_emacsclient
      fi

      if [ -d "$\{HOME\}/.config/emacs/bin" ]; then
          export PATH="$\{PATH\}":"$\{HOME\}/.config/emacs/bin"
      fi
    '';
  };
  programs.starship.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      source ~/.vimrc
    '';
  };

  home.file = {
    "${config.home.homeDirectory}/.vimrc" = { source = ../files/vim/vimrc; };
  };
}
