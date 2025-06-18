# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
#let
#nextcloudHostname = "nextcloudpy.com"; # Or "YOUR_NIXOS_IP_ADDRESS"
#nextcloudIpAddress = "YOUR_NIXOS_IP_ADDRESS"; # Replace with your actual server's local IP (e.g., 192.168.1.100)
#nextcloudPath = "/var/lib/nextcloud";
#in
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
    kernel.sysctl = {
      # Allow unprivileged users to bind to ports >=80 (instead of default 1024)
      "net.ipv4.ip_unprivileged_port_start" = 80;
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

  #services.udev.extraRules = ''
  #SUBSYSTEM=="net", ACTION=="add", KERNEL=="enp2s0", RUN+="${pkgs.ethtool}/bin/ethtool -s %k wol g"
  #'';

  systemd.network = {
    enable = true;
    networks."10-enp1s0" = {
      matchConfig.Name = "enp1s0";
      address = [ "192.168.124.76/24" ];
      gateway = [ "192.168.124.1" ];
      networkConfig = {
        DHCP = "no";
        IPv6AcceptRA = false;
      };
      linkConfig = {
        RequiredForOnline = "routable"; # Optional: makes boot wait until this is routable
      };
    };
    links."10-enp1s0" = {
      matchConfig.Name = "enp1s0";
      linkConfig.WakeOnLan = "magic";
    };
    wait-online.enable = true;
    wait-online.anyInterface = true;
  };

  systemd.services.enable-wol = {
    description = "Enable Wake-on-LAN";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/sbin/ethtool -s enp1s0 wol g";
    };
  };

  networking = {
    hostName = "NixNAS";

    useNetworkd = true;
    useDHCP = false;

    nftables.enable = true;
    #interfaces = {
    #enp1s0 = {
    #wakeOnLan.enable = true;
    #ipv4.addresses = [
    #{
    #address = "192.168.124.76";
    #prefixLength = 24;
    #}
    #];
    #};
    ##enp2s0 = {
    ##wakeOnLan.enable = false;
    ##ipv4.addresses = [
    ##{
    ##address = "192.168.124.77";
    ##prefixLength = 24;
    ##}
    ##];
    ##};
    #};

    defaultGateway = {
      address = "192.168.124.1";
      interface = "enp1s0";
    };

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        2283
        56789
        3478
        139 # samba
        445 # samba
        3389 # XRDP
      ];
      allowedUDPPorts = [
        2283
        3478
        137 # samba
        138 # samba
      ]; # 2283:immich 3478 8080 8443 nextcloud
      trustedInterfaces = [
        "tun0"
        "wlo1"
        "enp1s0"
        "enp2s0"
      ];
    };

    #extraHosts = ''
    #192.168.124.15 nextcloud.tailffcc5b.ts.net
    #'';

    #proxy = {
    #default = "http://192.168.124.9:10808/";
    ##noProxy = "127.0.0.1,localhost,internal.domain";
    #};

    #useHostResolvConf = false;
    #resolvconf = {
    #enable = true;
    ##useLocalResolver = true;
    #};
    nameservers = [
      "127.0.0.1"
      "8.8.8.8"
      "1.1.1.1"
    ];

    #wireless = {
    #iwd = {
    #enable = false;
    #settings = {
    #General = {
    #EnableNetworkConfiguration = true;
    #};
    #Network = {
    #EnableIPv6 = true;
    #RoutePriorityOffset = 300;
    #};
    #Settings = {
    #AutoConnect = true;
    #};
    #};
    #};
    #};
    networkmanager = {
      enable = false;
      #wifi.backend = "iwd";
      dns = "systemd-resolved";
    };
  };

  services.resolved = {
    enable = true;
    fallbackDns = [
      "8.8.8.8"
      "1.1.1.1"
    ];
    #fallbackDns = [ "127.0.0.1" ];
    #extraConfig = ''
    #DNS=127.0.0.1
    #DNSStubListener=yes
    #Domains=~.
    #'';
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      AllowUsers = [ "py" ]; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = false;
      X11Forwarding = true;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  services.immich = {
    enable = false;
    port = 2283;
  };

  systemd.tmpfiles.rules = [
    #"d /var/log/samba 0755 root root"
    "d /storage/myfiles 2770 root sambashare"
  ];

  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        security = "user";
        #"log level" = "auth:10 passdb:10 all:5";
        #"log file" = "/var/log/samba/log.%m"; # THIS IS CRUCIAL
        #"max log size" = "50000";
        ##"unix password sync" = "no";
        #"enable pam" = "no";
        #"idmap config *" = "backend tdb";
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "hosts allow" = "192.168.124. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "never";
        "name resolve order" = "bcast host";
        "min protocol" = "SMB2";
        "max protocol" = "SMB3";
      };

      "myfiles" = {
        path = "/storage/myfiles";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0660";
        "directory mask" = "2770";
        #"create mask" = "0644";
        #"directory mask" = "0755";
        "force user" = "sambauser";
        "force group" = "sambashare";
        #"valid users" = [ "@sambashare" ]; #can't turn on!!!!why?????
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  virtualisation.docker = {
    enable = true;

    daemon.settings = {
      # Use port 20172 for HTTP protocol with "Rule of Splitting Traffic"
      "http-proxy" = "http://127.0.0.1:20172";
      "https-proxy" = "http://127.0.0.1:20172";
      # It's important to tell Docker not to proxy internal Docker network traffic.
      # 172.17.0.0/16 is the default Docker bridge.
      # 172.20.0.0/16 is the range for 'nextcloud-aio' network in your compose.yml.
      "no-proxy" = "localhost,127.0.0.1,172.17.0.0/16,172.20.0.0/16";
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    daemon.settings = {
      dns = [
        "8.8.8.8"
        "1.1.1.1"
      ];
    };
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
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-chinese-addons
        fcitx5-pinyin-zhwiki
        fcitx5-nord
      ];
    };
  };

  services.seatd.enable = true;

  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_NO_PLASMA_INTEGRATION = "1";
    QT_STYLE_OVERRIDE = "Fusion";
  };

  services.haveged.enable = true;
  programs.dconf.enable = true;

  #services.getty.autologinUser = "py";
  #security.polkit.enable = true;
  #security.pam.services.gdm-password.enableGnomeKeyring = true;
  programs.seahorse.enable = false;
  #services.xserver.windowManager.twm.enable = true;
  services = {
    xserver = {
      enable = false;
      displayManager = {
        startx.enable = true;
      };
      desktopManager.xfce.enable = false;
    };
    displayManager = {
      autoLogin = {
        enable = false;
        user = "py";
      };
      gdm.enable = false;
      sddm.enable = false;
    };
    desktopManager = {
      gnome = {
        enable = false;
      };
      plasma6 = {
        enable = true;
      };
    };
  };

  services.x2goserver.enable = false;
  services = {
    xrdp = {
      enable = true;
      defaultWindowManager = "startplasma-x11";
      openFirewall = true;
      #extraConfDirCommands = ''
      #cat <<EOF > $out/custom-globals.ini
      #[Globals]
      #ListenAddress=0.0.0.0
      #EnableSyslog=true
      #EnableConsole=false
      #MaxSessions=10

      #[Xvnc]
      #name=Xvnc
      #lib=libvnc.so
      #username=ask
      #password=ask
      #ip=127.0.0.1
      #port=-1
      #code=20
      #EOF

      ##cat <<EOF > $out/custom-sesman.ini
      ##[Sessions]
      ##X11DisplayOffset=20
      ##EOF
      #'';
    };
  };

  #services.gnome.gnome-remote-desktop.enable = true;
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  hardware.graphics.enable = true;

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

  services.tailscale.enable = false;

  #services.nextcloud = {
  #enable = false;
  #package = pkgs.nextcloud31;
  #hostName = nextcloudHostname;
  #config = {
  ##adminuser = "admin";
  #adminpassFile = "/var/nextcloudpass/nextcloud-admin-pass";
  #dbtype = "pgsql";
  #};
  #settings = {
  #overwritehost = nextcloudHostname; # Tell Nextcloud its external host
  #overwriteprotocol = "https"; # Tell Nextcloud it's accessed via HTTPS
  #trusted_proxies = [ "127.0.0.1" ]; # Nginx is proxying from localhost
  #trusted_domains = [
  #nextcloudHostname
  #nextcloudIpAddress
  #];
  #};
  #https = false;
  ##datadir = "${nextcloudPath}";

  #database.createLocally = true;
  #phpOptions = {
  ##"memory_limit" = "1G";
  #"opcache.enable" = "true";
  #"opcache.interned_strings_buffer" = "16";
  #"opcache.memory_consumption" = "128";
  #"opcache.save_comments" = "1";
  #"opcache.revalidate_freq" = "1";
  #};
  #configureRedis = true;

  #nginx.recommendedHttpHeaders = true;
  #};

  #security.acme = {
  #certs."${nextcloudHostname}".email = "pierrez1984@gmail.com";

  #acceptTerms = true;

  ## Optionally, set a staging environment for testing before going live
  ## useStaging = true;  # Uncomment to use Let's Encrypt's staging environment (for testing)
  #};

  #services.nginx = {
  #enable = false;
  #virtualHosts."${nextcloudHostname}" = {
  ##root = "${nextcloudPath}";
  #serverName = "${nextcloudHostname}";

  ##enableACME = true; # Enable automatic SSL certificate from Let's Encrypt

  #sslCertificate = "/etc/nginx/ssl/nextcloud.crt";
  #sslCertificateKey = "/etc/nginx/ssl/nextcloud.key";
  #listen = [
  #{
  #port = 80;
  #addr = "0.0.0.0";
  #} # Listen on all IP addresses for HTTP
  #{
  #port = 443;
  #ssl = true;
  #addr = "0.0.0.0";
  #} # Listen on all IP addresses for HTTPS
  #];
  #http2 = true;
  #http3 = true;
  #forceSSL = true; # Redirect HTTP to HTTPS
  #locations."/" = {
  #proxyPass = "unix:/run/php/php7.4-fpm.sock|fcgi://localhost";
  #tryFiles = "$uri $uri/ =404";
  ##proxySetHeader = [
  ##"Host $host"
  ##"X-Real-IP $remote_addr"
  ##"X-Forwarded-For $proxy_add_x_forwarded_for"
  ##];
  #};
  #};
  #};

  # Define a virtual host in Nginx for your Nextcloud instance
  #services.nginx.virtualHosts."${nextcloudHostname}" = {
  ## Listen for HTTPS traffic on port 443
  #listenAddresses = [
  ## Listen for HTTPS traffic on port 443 with SSL enabled
  #{
  #addr = "0.0.0.0";
  #port = 443;
  #ssl = true;
  #}
  ## Listen for HTTP traffic on port 80 (for redirect to HTTPS)
  #{
  #addr = "0.0.0.0";
  #port = 80;
  #}
  #];
  ## Path to your self-signed SSL certificate and key
  #sslCertificate = "/etc/ssl/nextcloud/nextcloud.crt";
  #sslCertificateKey = "/etc/ssl/nextcloud/nextcloud.key";

  ## Proxy requests to the Nextcloud PHP-FPM socket.
  ## Use lib.mkForce to ensure this definition takes precedence if the Nextcloud module
  ## tries to define its own location block for this virtual host.
  #locations."/" = lib.mkForce {
  #proxyPass = "unix:${config.services.nextcloud.phpFpmSocket}";
  #recommendedProxySettings = true;
  #};

  #extraConfig = ''
  #if ($scheme = http) {
  #return 301 https://$host$request_uri;
  #}
  #rewrite /.well-known/carddav /remote.php/dav permanent;
  #rewrite /.well-known/caldav /remote.php/dav permanent;
  #'';
  #};

  services.postgresql = {
    enable = false;
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

  users.users.py = {
    isNormalUser = true;
    description = "py";
    group = "users";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhppLSZ+s+f27ZY7YkDwCQFF5dILpqV9uqj1UmyuPqs py@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHgx0PpBOGsgLTIQqlxparz3/fAb4vymWzjgtxa0Xod4 py@PY-MAC.local"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCoyDQ+L3UX+yMS/ADOP8AtrLlOlHKDsRbvLeahBPuVQ0mW0Eaw0FvluUa0GF0E79lAMfKkAfHru4TdIGhGI/kusYGD63wYritUQuqQmIOGAbAdfckWdVTc9tL6lq7X4WVtIhAC/Fn66aomQgadq1lwFJoJFswipXaKPjEfbt6x7RYpNTTcjjE9goChgT6j6paWvcn/bpWW1sIi7MgijX6eFd0q8bNQW1YyKAGPjQRAiI+awcE3osdGxoFyiM4d5H2vWiMaGjupgyAFkz/OUHgFd5Vl8aCyq4i/NgRSeeqVT780VdY51o6wf5w5/3QO5yMrkoZpGwyzoIuGdS26j2TH py@SC-201207261047"
    ];
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
      "video"
      "jackaudio"
      "seat"
      "sambashare"
    ];
    packages = with pkgs; [
    ];
  };

  users.groups.sambashare = { };
  users.users.sambauser = {
    isNormalUser = true;
    group = "sambashare";
    description = "Samba user for local usage.";
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
    xorg.xauth
    xclip
    wev
    sxhkd
    libsForQt5.qt5.qtbase
    gnome-remote-desktop
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
    php
    gparted
    pciutils
    cpu-x

    xorg.xorgserver
    wayvnc
    tigervnc
    #ngrok
    #nextcloud-client
    #sing-box
    #gui-for-singbox
  ];

  programs.zsh.enable = true;
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

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    tunMode = true;
    serviceMode = true;
  };

  services.shadowsocks.enable = false;
  services.v2raya.enable = true;
  services.v2ray.enable = false;
  services.xray.enable = false;
  services.mullvad-vpn.enable = false;

  services.dictd.enable = false;

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
    group = "sambashare";
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
      download_location = "/storage/myfiles/movies/";
      max_active_limit = 15;
      max_active_downloading = 15;
      max_active_seeding = 10;
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
