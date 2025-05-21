# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.substituters = [
    "https://mirror.sjtu.edu.cn/nix-channels/store"
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
  ];
  #nix.settings.substituters = lib.mkBefore [ "https://mirror.sjtu.edu.cn/nix-channels/store" "https://mirrors.ustc.edu.cn/nix-channels/store" "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

  systemd.extraConfig = "DefaultLimitNOFILE=4096";
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [ "tun" ];
  };

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
    HandlePowerKeyLongPress=poweroff
  '';

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
    HibernateDelaySec=1h
  '';

  networking = {
    hostName = "NixNAS";

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [
        2283
        56789
      ];
      allowedUDPPorts = [ 2283 ]; # 2283:immich
      trustedInterfaces = [ "tun0" ];
    };
    #proxy = {
    #default = "http://192.168.124.9:10808/";
    ##noProxy = "127.0.0.1,localhost,internal.domain";
    #};

    useHostResolvConf = false;
    resolvconf = {
      enable = false;
      #useLocalResolver = true;
    };
    #nameservers = [ "127.0.0.1" ];
  };

  services.resolved = {
    enable = true;
    fallbackDns = [ "127.0.0.1" ];
    extraConfig = ''
      DNS=127.0.0.1
      DNSStubListener=yes
      Domains=~.
    '';
  };

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = false;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-chinese-addons
        fcitx5-pinyin-zhwiki
        fcitx5-nord
      ];
    };
  };

  services.seatd.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  programs.sway = {
    enable = false;
    wrapperFeatures.gtk = true;
  };
  programs.hyprland = {
    enable = false;
    xwayland.enable = true;
  };
  programs.labwc = {
    enable = true;
  };

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_NO_PLASMA_INTEGRATION = "1";
    QT_STYLE_OVERRIDE = "Fusion";
  };

  services.haveged.enable = true;

  services.getty.autologinUser = "py";

  security.polkit.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  hardware.uinput.enable = true;

  programs.ydotool.enable = true;

  services.printing.enable = true;

  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
    extraConfig.pipewire = {
      "10-clock-rate" = {
        "context.properties" = {
          "default.clock.rate" = 44100;
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 1024;
          "default.clock.max-quantum" = 1024;
        };
      };
    };
    wireplumber = {
      enable = true;
      extraConfig.bluetoothEnhancements = {

        "monitor.bluez.properties" = {
          "bluez5.default.rate" = 44100;
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "a2dp_sink"
            "a2dp_source"
            "bap_sink"
            "bap_source"
            "hfp_hf"
            "hfp_ag"
            "hsp_hs"
            "hsp_ag"
          ];
        };

        "monitor.bluez.rules" = {
          matches = [
            {
              "node.name" = "~bluez_input.*";
            }
            {
              "node.name" = "~bluez_output.*";
            }
          ];
          actions = {
            update-props = {
              "session.suspend-timeout-seconds" = 0;
            };
          };
        };

      };
    };
  };

  fonts.packages = with pkgs; [
    # https://wiki.archlinux.org/title/Font_configuration
    font-awesome
    uw-ttyp0
    gohufont
    terminus_font_ttf
    profont
    efont-unicode
    noto-fonts-emoji
    dina-font

    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.hack

    # for Chinese
    source-han-serif
    source-han-sans

    vistafonts
    ubuntu_font_family

  ];

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users.users.py = {
    isNormalUser = true;
    description = "py";
    extraGroups = [
      "input"
      "evdev"
      "uinput"
      "networkmanager"
      "wheel"
      "docker"
      "ydotool"
      "deluge"
      "audio"
      "jackaudio"
      "seat"
    ];
    packages = with pkgs; [
    ];
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  environment.systemPackages = with pkgs; [
    qjackctl
    libjack2
    jack2
    pavucontrol
    bluez-tools
    pulseaudioFull

    thermald
    powertop
    smartmontools
    dmidecode
    acpi
    brightnessctl
    libimobiledevice
    ifuse
    wget
    gsimplecal
    wmctrl

    kdePackages.qt6ct
    libsForQt5.qt5ct
    kdePackages.breeze-icons
    gnome-icon-theme
    shared-mime-info

    bibata-cursors
    nordzy-cursor-theme
    numix-cursor-theme
    openzone-cursors
    vimix-cursors
    volantes-cursors
    xdotool
    xautomation
    libinput-gestures
    libinput
    inxi
    xorg.xev
    wev
    sxhkd
    libsForQt5.qt5.qtbase
    kdePackages.qtbase
    kdePackages.kglobalacceld
    kdePackages.kglobalaccel
    libsForQt5.kglobalaccel
    kdePackages.qttools
    kdePackages.qtmultimedia
    libsForQt5.breeze-qt5
    libsForQt5.ki18n
    libsForQt5.qt5ct
    kdePackages.ki18n
    playerctl
    qpwgraph
    virtualgl
    font-manager
    fontpreview

    sing-box
    gui-for-singbox
  ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  ];

  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff \
           /run/current-system "$systemConfig"
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  programs.bandwhich.enable = true;
  networking.nftables.enable = true;

  services.openssh.enable = true;
  programs.clash-verge.enable = true;
  services.shadowsocks.enable = false;
  services.v2raya.enable = false;
  services.v2ray.enable = false;
  services.xray.enable = false;
  services.mullvad-vpn.enable = false;

  services.dictd.enable = true;

  services.syncthing = {
    enable = true;
    user = "py";
    dataDir = "/home/py/Sync";
    openDefaultPorts = true;
  };

  services.deluge = {
    enable = true;
    declarative = true;
    user = "py";
    dataDir = "/home/py";
    openFirewall = true;
    authFile =
      let
        deluge_auth_file = (
          builtins.toFile "auth" ''
            localclient::10
          ''
        );
      in
      deluge_auth_file;
    config = {
      allow_remote = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
