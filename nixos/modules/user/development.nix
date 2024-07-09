{ lib, config, pkgs, ... }:

let cfg = config.development-user;
in {
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
  config = {
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
      unzip

      # Fonts
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code

      # Dev tools
      tokei
      openssh

      # Python
      python312
      uv

      # nix
      nil
      statix
      nixfmt-classic

      pandoc

      shellcheck
      shfmt

      graphviz

      rstfmt

      nodejs

      claude-code
    ];

    fonts.fontconfig.enable = true;

    # Update path for bash profile
    home = {
      sessionPath = [ "$HOME/.config/emacs/bin" ];
      file = {
        "${config.home.homeDirectory}/.vimrc" = {
          source = ../../files/vim/vimrc;
        };
      };
    };

    services.ssh-agent.enable = true;

    programs = {
      starship.enable = true;
      neovim = {
        enable = true;
        defaultEditor = true;
        extraConfig = ''
          source ~/.vimrc
        '';
      };

      git = {
        enable = true;
        userName = cfg.fullName;
        userEmail = cfg.email;
        difftastic.enable = true;
        extraConfig = {
          core.editor = "nvim";
          rebase = {
            autoSquash = true;
            autoStash = true;
            updateRefs = true;
          };
          pull.rebase = true;
          merge.conflictstyle = "zdiff3";
          column.ui = "auto";
          branch.sort = "version:refname";
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

          # Allow applications to locate shared libraries. For example, jupyter
          # notebook needs to locate libstdc++.so.6.
          # export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib"
        '';
      };
    };
  };
}
