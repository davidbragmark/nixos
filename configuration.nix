# Edit this configuration file to define what should be installed on
# your system.  Hielp is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: let
  hostName = "nixos";
  user = "david";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./vpn.nix
    ./nvidia.nix
    ./stylix.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  # Setup keyfile
  boot.initrd.secrets = {"/crypto_keyfile.bin" = null;};

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = hostName; # Define your hostname.
  networking.extraHosts = ''
    # pgrok helper
    127.0.0.1 pgrok.me

    # Databases in Azure - West Europe
    172.20.253.148	psql-ecom-shared-weu-001.postgres.database.azure.com
    172.20.254.36	psql-ecom-prod-weu-001.postgres.database.azure.com

    # Databases in Azure - Sweden Central
    172.20.251.21	psql-ecom-shared-sec-001.postgres.database.azure.com
  '';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://fpx-primary.valtech.com:8080";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  hardware.tuxedo-rs = {
    enable = true;
    tailor-gui.enable = true;
  };

  services.pppd.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";

      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 50;

      # 100 being the maximum, limit the speed of my CPU to reduce
      # heat and increase battery usage:
      CPU_MAX_PERF_ON_AC = 85;
      CPU_MAX_PERF_ON_BAT = 40;
    };
  };

  # sound = {
  #   enable = true;
  #   mediaKeys.enable = true;
  # };

  hardware = {
    # pulseaudio = {
    #   enable = true;
    #   support32Bit = true;
    #   extraConfig = "
    #     # Automatically switch audio to the connected bluetooth device when it connects.
    #     load-module module-switch-on-connect
    #   ";
    # };
    bluetooth = {
      enable = true;
      settings = {
        General = {
          # Modern headsets will generally try to connect using the A2DP profile.
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };

  security.rtkit.enable = true;

  services = {
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  virtualisation.docker.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  services.displayManager = {
    defaultSession = "none+i3";
    autoLogin.enable = true;
    autoLogin.user = "${user}";
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    dpi = 120;
    videoDrivers = ["displaylink"];
    xkb.layout = "us_programmer,real-prog-qwerty";
    xkb.options = "ctrl:nocaps,grp:alt_shift_toggle";
    xkb.variant = "";
    xkb.extraLayouts.us_programmer = {
      description = "Eng programmer's layout";
      languages = ["eng"];
      symbolsFile = ./symbols/us_programmer;
    };

    xkb.extraLayouts.real-prog-qwerty = {
      description = "English (Real Programmers Qwerty)";
      languages = ["eng"];
      symbolsFile = ./symbols/real-prog-qwerty;
    };

    displayManager = {
      lightdm.enable = true;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        pamixer
        brightnessctl
        wl-clipboard

        i3blocks
        i3lock
        i3status
        xkb-switch-i3
        polybar
        rofi
        xorg.xbacklight
        dex
        feh
        acpi
        picom
        sysstat
        lm_sensors
        mpd
        scrot
        dunst
        neofetch
        imagemagick
        viu
      ];
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      jetbrains-mono
      iosevka

      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
    ];
  };

  environment.localBinInPath = true;

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    home = "/home/david";
    shell = pkgs.zsh;
    description = "${user}";
    extraGroups = ["docker" "networkmanager" "wheel" "audio"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    vim
    git
    curl
    wget
    nvimpager
  ];

  environment = {
    sessionVariables = {
      XDG_CACHE_HOME = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_BIN_HOME = "\${HOME}/.local/bin";
      XDG_DATA_HOME = "\${HOME}/.local/share";
      XDG_RUNTIME_DIR = "/run/user/1000";
      EDITOR = "nvim";
      PAGER = "nvimpager";
    };

    shells = with pkgs; [
      zsh
      fish
      nushell
    ];

    pathsToLink = [
      "/share/nix-direnv"
    ];
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.picom.vSync = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  security.sudo.extraRules = [
    {
      users = ["${user}"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
