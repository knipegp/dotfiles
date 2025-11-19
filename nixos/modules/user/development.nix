{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.development-user;
in
{
  options.development-user = {
    fullName = lib.mkOption {
      default = "Griffin Knipe";
      description = "username";
    };
    email = lib.mkOption {
      default = "knipegp@proton.me";
      description = "email";
    };
  };
  imports = [ ../../modules/user/python-dev.nix ];
  config = {
    home.packages = with pkgs; [
      # Basic terminal tools
      tealdeer
      eza
      ripgrep
      bottom
      dust
      sd
      procs
      fd
      bat
      neofetch
      unzip
      zellij
      gh

      # Common project tools
      prek

      # Fonts
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code

      # Dev tools
      tokei
      openssh

      # nix
      nil
      statix
      deadnix
      nixfmt-classic

      pandoc

      shellcheck
      shfmt

      graphviz

      rstfmt

      nodejs

      claude-code

      # for raw image previews with kitten icat and ranger
      imagemagick
      ueberzugpp
      ranger
    ];

    fonts.fontconfig.enable = true;

    # Update path for bash profile
    home = {
      sessionPath = [ "$HOME/.config/emacs/bin" ];
      file = {
        "${config.home.homeDirectory}/.vimrc" = {
          source = ../../files/vim/vimrc;
        };
        "${config.home.homeDirectory}/.local/bin/motd" = {
          source = ../../files/motd;
          executable = true;
        };
        "${config.home.homeDirectory}/.config/ranger/rc.conf" = {
          source = ../../files/ranger/rc.conf;
        };
        "${config.home.homeDirectory}/.config/ranger/scope.sh" = {
          source = ../../files/ranger/scope.sh;
          executable = true;
        };
      };
    };

    services.ssh-agent.enable = true;

    programs = {
      yazi.enable = true;
      starship.enable = true;
      neovim = {
        enable = true;
        defaultEditor = true;
        extraConfig = ''
          source ~/.vimrc
        '';
      };

      difftastic.enable = true;
      git = {
        enable = true;
        settings = {
          user = {
            name = cfg.fullName;
            inherit (cfg) email;
          };
          core.editor = "nvim";
          rebase = {
            autoSquash = true;
            autoStash = true;
            updateRefs = true;
          };
          pull.rebase = true;
          merge.conflictstyle = "zdiff3";
          column.ui = "auto";
          init.defaultBranch = "main";
          diff = {
            algorithm = "histogram";
            colorMoved = "plain";
            mnemonicPrefix = true;
            renames = true;
          };
          push = {
            default = "simple";
            autoSetupRemote = true;
            followTags = true;
          };
          fetch = {
            prune = true;
            pruneTags = true;
            all = true;
          };
          branch = {
            sort = "version:refname";
            autosetupmerge = "always";
            autosetuprebase = "always";
          };
          help.autocorrect = "prompt";
          commit.verbose = true;
          rerere = {
            enabled = true;
            autoupdate = true;
          };
        };
        signing.signByDefault = true;
        signing.key = null;
      };

      bash = {
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

          if [ -d "''${HOME}/.local/bin" ]; then
              export PATH="''${PATH}":"''${HOME}/.local/bin"
          fi

          # Run MOTD on interactive shell startup
          if [[ $- == *i* ]] && command -v motd >/dev/null 2>&1; then
              motd
          fi
        '';
      };
    };
  };
}
