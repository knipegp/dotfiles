{ lib, config, pkgs, services, ... }:

let cfg = config.development-user;
in {
  options.development-user = {
    enable = lib.mkEnableOption "enable development user module";
    fullName = lib.mkOption {
      default = "Griffin Knipe";
      description = "username";
    };
    email = lib.mkOption {
      default = "knipegp@gmail.com";
      description = "email";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
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
    ];
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "always";
    };

    programs.git = {
      enable = true;
      userName = cfg.fullName;
      userEmail = cfg.email;
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

        if [ -d "''${HOME}/.config/emacs/bin" ]; then
            export PATH="''${PATH}":"''${HOME}/.config/emacs/bin"
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
    services.ssh-agent.enable = true;
  };

}
