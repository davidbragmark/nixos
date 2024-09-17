{
  config,
  pkgs,
  ...
}: let
  cache = config.xdg.cacheHome;
  configHome = config.xdg.configHome;

  dotnet-sdks = with pkgs.unstable; (with dotnetCorePackages; combinePackages [sdk_6_0 sdk_7_0 sdk_8_0]);
in {
  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  home.stateVersion = "23.05";

  home.packages = [
    # neovim dependencies
    pkgs.gcc
    pkgs.cmake
    pkgs.gnumake
    pkgs.libstdcxx5
    pkgs.libgdiplus
    pkgs.file
    pkgs.openvpn
    pkgs.foliate
    pkgs.tree-sitter
    pkgs.fd
    pkgs.fzf
    pkgs.delta
    pkgs.grc
    pkgs.expect
    pkgs.ripgrep
    # pkgs.neovim-nightly
    pkgs.unstable.neovim
    pkgs.unzip
    pkgs.zip
    pkgs.gzip
    pkgs.gnutar
    pkgs.dunst
    pkgs.xclip
    pkgs.htop
    pkgs.btop
    pkgs.inxi
    pkgs.glxinfo
    pkgs.starship
    pkgs.zoxide
    pkgs.xfce.thunar
    pkgs.broot
    pkgs.atuin
    pkgs.colemak-dh

    pkgs.gh
    pkgs.hub
    pkgs.jq
    pkgs.unstable.eza
    pkgs.lf
    pkgs.bat
    pkgs.tree
    pkgs.mmv
    pkgs.bemenu
    pkgs.wezterm
    pkgs.pgrok
    pkgs.firefox
    #pkgs.unstable.brave
    pkgs.pavucontrol
    pkgs.pulsemixer
    pkgs.pulseaudio
    pkgs.mpv
    pkgs.arandr
    pkgs.autorandr # Automatic XRandR configurations
    pkgs.upower
    pkgs.zlib
    pkgs.xdotool
    pkgs.mellowplayer
    pkgs.libreoffice-fresh

    pkgs.bitwarden-cli

    pkgs.discord
    pkgs.slack
    pkgs.discordo
    #pkgs.teams-for-linux

    # Programming GUI programs
    pkgs.unstable.jetbrains.rider
    pkgs.android-tools
    pkgs.beekeeper-studio
    pkgs.unstable.androidStudioPackages.dev

    # Languages
    pkgs.mono
    pkgs.azure-cli
    dotnet-sdks
    pkgs.unstable.nodejs_18
    pkgs.cargo
    pkgs.minizinc
    pkgs.python39
    pkgs.pgadmin4
    pkgs.ocaml
    pkgs.opam
    pkgs.ocamlPackages.stdune
    pkgs.alejandra
    pkgs.unstable.nil
    pkgs.fantomas
    pkgs.stylua
    pkgs.csharpier
    pkgs.netcoredbg

    # Language servers
    pkgs.omnisharp-roslyn
    pkgs.ocamlPackages.ocaml-lsp
    pkgs.unstable.kotlin-language-server
    pkgs.unstable.lua-language-server
    pkgs.nodePackages.vim-language-server
    pkgs.nodePackages.typescript-language-server
    pkgs.sqls

    pkgs.light
    pkgs.lshw

    pkgs.openconnect
    pkgs.globalprotect-openconnect
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "wezterm";
    TERM = "wezterm";
    LESSHISTFILE = cache + "/less/history";

    DOTNET_ROOT = "${pkgs.dotnet-sdk}";
  };

  ## TODO: Breakout programs into separate file/structure
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = import ./git.nix {inherit pkgs;};

  programs.zsh = import ./zsh.nix {inherit pkgs;};

  programs.zoxide = {
    enable = true;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.broot = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      modal = true;
      verbs = [
        {
          invocation = "blop {name}\\.{type}";
          execution = "mkdir {parent}/{type} && nvim {parent}/{type}/{name}.{type}";
          from_shell = true;
        }
      ];
    };
  };

  programs.home-manager.enable = true;
}
