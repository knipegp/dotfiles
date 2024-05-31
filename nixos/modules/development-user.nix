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
      default = "knipegp@proton.me";
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
      openssh # ssg-agent

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

      # User tools
      udiskie
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
      signing.signByDefault = true;
      signing.key = null;
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

        if [[ -z "$SSH_AUTH_SOCK" ]]; then
          export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent
        fi
      '';
    };

    # Update path for bash profile
    home.sessionPath = [ "$HOME/.config/emacs/bin" ];

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
  };

}
