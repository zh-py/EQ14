#ln -s ~/Insync/pierrez1984@gmail.com/Dropbox/mac_config/home-manager ~/.config
#ln -s ~/Dropbox\ \(Maestral\)/mac_config/mac_nix/nixos /etc
#ln -sf /etc/nixos/dotfiles/hyprland.conf ~/.config/hypr
#ln -sf /etc/nixos/dotfiles/.xinitrc ~/.config/

# in ~/.config/lxqt/session.conf or lxqt session setting
#GTK_IM_MODULE=fcitx5
#QT_IM_MODULE=fcitx5
#QT_PLATFORM_PLUGIN=qt5ct
#QT_QPA_PLATFORMTHEME=qt5ct
#XMODIFIERS%3D%40im%3Dfcitx=fcitx5

{
  config,
  pkgs,
  lib,
  ...
}:
{
  #}: let
  #inherit (pkgs.lib) mkIf optionals;
  #tex = (pkgs.texlive.combine {
  #inherit (pkgs.texlive) scheme-full;
  #});
  #in {
  home.username = "py";
  home.homeDirectory = "/home/py";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  #dconf = {
  #enable = true;
  #settings = {
  #"org/gnome/shell" = {
  #disable-user-extensions = false;
  #enabled-extensions = with pkgs.gnomeExtensions; [
  #kimpanel
  #];
  #};
  #};
  #};

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  home.packages = with pkgs; [
    #nixos only
    #clash-nyanpasu
    #clash-meta
    #metacubexd
    #clash-rs
    #shadowsocks-rust
    #flclash
    #v2rayn
    dig
    ethtool

    #gui-for-clash
    immich-go
    fusuma
    proxychains-ng
    redsocks
    iptables
    autossh

    firefox
    google-chrome
    #tor-browser
    #wechat-uos
    baidupcs-go
    #teams-for-linux
    #rustdesk
    #calibre
    koreader
    peazip
    nomacs
    gimp
    #ocenaudio
    libreoffice-qt6
    speedcrunch
    #photoqt
    qview
    viewnior
    krusader
    doublecmd
    lxqt.pcmanfm-qt
    pcmanfm
    xxdiff
    kdePackages.okular
    mupdf
    qpdfview
    poppler
    gpick
    telegram-desktop
    #ventoy
    #galculator
    qalculate-gtk
    playerctl
    bluetooth_battery
    texliveFull
    pstree
    bar
    pv
    mediainfo-gui
    trashy
    #insync
    maestral
    keepassxc
    #appimage-run
    dmenu
    #rofi-wayland
    rofi

    #share
    openssl
    mc
    eza
    lsof
    tldr
    bandwhich
    octaveFull
    sagetex
    openblas
    exfatprogs
    progress
    calcurse
    hunspell
    #cava
    xsel
    libheif
    imagemagick
    powerstat
    lm_sensors
    nix-du
    nix-tree
    nix-index
    #unzip
    #unar
    graphviz
    gh
    wordnet
    yt-dlp
    btop
    htop
    neofetch
    fastfetch
    dust
    fd
    ripgrep
    bat
    delta
    fontconfig
    glances
    bottom
    aria2
    pay-respects
    rclone
    syncthing
    nil
    nixfmt
    pyright
    poetry
    ruff
    luajitPackages.luacheck
    lua-language-server
    marksman
    tree-sitter
    tree-sitter-grammars.tree-sitter-python
    texlab
    qbittorrent-enhanced
    rutorrent
    rtorrent
    #spotify
    spotdl
    lrcget
    #spotube
    vlc
    smplayer
    ffmpeg
    mkvtoolnix-cli
    zotero
    #netcdf
    #netcdffortran
    #mpich
    #jasper
    #libpng
    #zlib
    #gfortran
    #libgcc
    tcsh
    evtest-qt
    evtest

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

    #(python311.withPackages (p:
    #with p; [
    #extractcode
    #]))

    stack

    (python313.withPackages (
      p: with p; [
        py-cpuinfo
        #extractcode
        pip
        numpy
        jupyter
        qtconsole
        sympy
        requests
        pandas
        matplotlib
        pytz
        tenacity
        timeout-decorator
        ipdb
        ipython
        pysnooper
        debugpy
        python-lsp-server
        python-lsp-ruff
        pynvim
        send2trash
        openpyxl
        pytest
        torch
      ]
    ))
  ];

  services.mpris-proxy.enable = true;

  services.fusuma = {
    enable = false;
    extraPackages = with pkgs; [ xdotool ];
    #settings = ''
    #${builtins.readFile ./dotfiles/fusuma/settingconfig.yml}
    #'';
    #settings = builtins.readFile ./dotfiles/fusuma/config.yml;
    settings = {
      #threshold = { swipe = 0.1; };
      #interval = { swipe = 0.7; };
      swipe = {
        "4" = {
          left = {
            #command = "xdotool key ctrl+Right";
            #command = "xte 'keydown Control_L' 'key Right' 'keyup Control_L'";
            command = "ydotool key 29:1 106:1 106:0 29:0";
            threshold = 0.5;
            #interval = 0.75;
            interval = 0.8;
          };
          right = {
            #command = "xdotool key ctrl+Left";
            #command = "xte 'keydown Control_L' 'key Left' 'keyup Control_L'";
            command = "ydotool key 29:1 105:1 105:0 29:0";
            threshold = 0.5;
            #interval = 0.75;
            interval = 0.8;
          };
          up = {
            #command = "xdotool key ctrl+alt+m";
            command = "ydotool key 29:1 56:1 50:1 50:0 56:0 29:0";
            threshold = 0.1;
            interval = 0.5;
          };
        };
        "3" = {
          begin = {
            command = "ydotool click 40";
            interval = 0.0;
          };
          update = {
            command = "ydotool mousemove -- $move_x, $move_y";
            accel = 2;
            interval = 0.1;
          };
          end = {
            command = "ydotool click 80";
            interval = 0.0;
          };
        };
        #"3" = {
        #begin = {
        #command = "xdotool mousedown 1";
        #};
        #update = {
        #command = "xdotool mousemove_relative -- $move_x, $move_y";
        #accel = 2;
        #interval = 1.0e-3;
        #};
        #end = {
        #command = "xdotool mouseup 1";
        #};
        #};
        #"3" = {
        #begin = {
        #command = "xdotool mousedown 1";
        #interval = 0.0;
        #};
        #update = {
        #command = "xdotool mousemove_relative -- $move_x, $move_y";
        #accel = 2;
        #interval = 0.01;
        #};
        #end = {
        #command = "xdotool mouseup 1";
        #interval = 0.0;
        #};
        #};
      };
      pinch = {
        "4" = {
          "in" = {
            command = "xdotool key ctrl+alt+d";
            threshold = 0.5;
          };
          out = {
            command = "xdotool key ctrl+alt+d";
            threshold = 0.5;
          };
        };
        "2" = {
          "in" = {
            command = "xdotool keydown ctrl click 5 keyup ctrl";
            threshold = 2.0e-2;
          };
          out = {
            command = "xdotool keydown ctrl click 4 keyup ctrl";
            threshold = 2.0e-2;
          };
        };
      };
      plugin = {
        inputs = {
          libinput_command_input = {
            enable-tap = true;
            enable-dwt = true;
            show-keycodes = true;
          };
        };
      };
    };
  };

  #systemd.user.services.maestral = {
  #description = "Maestral daemon";
  #wantedBy = [ "default.target" ];
  #serviceConfig = {
  #Type = "notify";
  #NotifyAccess = "exec";
  #ExecStart = "/etc/profiles/per-user/py/bin/maestral start -f";
  #ExecStop = "/etc/profiles/per-user/py/bin/maestral stop";
  #ExecStopPost = "/run/current-system/sw/bin/bash -c \"if [ \\$SERVICE_RESULT != success ]; then /run/current-system/sw/bin/notify-send Maestral 'Daemon failed'; fi\"";
  #WatchdogSec = "30s";
  #Restart = "always";
  #};
  #};

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/mpv".source = dotfiles/mpv;
    #".config/wezterm/wezterm.lua".source = dotfiles/wezterm.lua;
    ".config/fusuma/config.yml".source = dotfiles/fusuma/config.yml;
    ".config/systemd/user/maestral.service".source = dotfiles/maestral.service;
    ".config/lf/lfcd.sh".source = dotfiles/lf-config/lfcd.sh;
    ".config/lf/lf.bash".source = dotfiles/lf-config/lf.bash;
    ".config/openbox/rc.xml".source = dotfiles/openbox/rc.xml;
    ".config/libinput-gestures.conf".source = dotfiles/libinput-gestures.conf;
    #".jupyter/jupyter_qtconsole_config.py".source = dotfiles/jupyter_qtconsole_config.py;
    #".config/calcurse/caldav/config".source = dotfiles/calcurse-caldav/config; #git doesn't allow, so manually copy
    #".config/lf".source = dotfiles/lf-config;
    #".config/lf/icons".source = dotfiles/lf-config/icons;
    #".Xmodmap".source = dotfiles/.Xmodmap;
    #".xkb".source = dotfiles/.xkb;
  };
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/py/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    #BROWSER = "firefox";
    #TERMINAL = "kitty";
    #XDG_CONFIG_HOME = "$HOME/.config";
    #XDG_CONFIG_HOME = lib.mkDefault "$HOME/.config";
  };

  xdg = {
    enable = false;
    mimeApps = {
      enable = false;
      defaultApplications = {
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "text/plain" = "nvim.desktop";
        "video/mp4" = "mpv.desktop";
        "video/mpeg" = "mpv.desktop";
        "video/quicktime" = "mpv.desktop";
        "video/x-msvideo" = "mpv.desktop";
        "video/x-flv" = "mpv.desktop";
        "image/png" = "nomacs.desktop";
        "image/jpeg" = "nomacs.desktop";
        "image/gif" = "nomacs.desktop";
        "image/bmp" = "nomacs.desktop";
        "image/webp" = "nomacs.desktop";
      };
    };
  };

  # Let Home Manager install and manage itself.

  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      { package = pkgs.gnomeExtensions.kimpanel; }
      #{ package = pkgs.gnomeExtensions.dash-to-dock; }
      #{ package = pkgs.gnomeExtensions.gsconnect; }
    ];
  };
  programs.home-manager.enable = true;
  programs.sagemath.enable = false;
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
    };
  };

  programs.mpv = {
    # mkdir /var/log/mpv && sudo chmod -R u=rwx,g=rwx,o=rwx /var/log/mpv    ### for recent.lua history.log
    enable = true;
    scripts = with pkgs.mpvScripts; [
      sponsorblock
      mpris
      thumbfast
      #uosc
    ];
  };

  #programs.mpv = {
  #enable = true;
  #bindings = {
  #"Alt+0" = "set window-scale 0.5";
  #};
  #config = {
  #ytdl-format="bestvideo[height<=?480][fps<=?30][vcodec!=?webm]+bestaudio/best";
  #cache-default = 4000000;
  #};
  #};

  #programs.tint2 = {
  #enable = true;
  #extraConfig = builtins.readFile ./dotfiles/tint2rc;
  #};

  programs.wofi = {
    enable = false;
    settings = {
    };
  };

  programs.tofi = {
    enable = false;
    settings = {
    };
  };

  programs.lf = {
    enable = true;
    settings = {
      number = true;
      relativenumber = true;
      hidden = true;
      icons = false;
    };
    keybindings = {
      gh = "cd ~";
      gd = "cd ~/Downloads";
      gc = "cd ~/.config";
      gn = "cd /etc/nixos/";
      DD = "trash";
      md = "mkdir";
      i = "$less $f";
      oo = "extractcode";
      sp = "usage";
      Q = "quit-and-cd";
    };
    extraConfig = ''
      #!/bin/sh
      #https://github.com/gokcehan/lf/wiki/Tips
      cmd trash $IFS="$(printf '\n\t')"; trash $fx
      cmd extractcode $IFS="$(printf '\n\t')"; extractcode $fx
      cmd usage $du -h -d1 | less
      cmd quit-and-cd &{{
        pwd > $LF_CD_FILE
        lf -remote "send $id quit"
      }}
      #cmd open &{{
        #case $(file --mime-type -Lb $f) in
          #text/*) lf -remote "send $id \$$EDITOR \$fx";;
          #*) for f in $fx; do $OPENER $f > /dev/null 2> /dev/null & done;;
        #esac
      #}}
    '';
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "pierrez1984@gmail.com";
        name = "zh-py";
      };
      core = {
        editor = "nvim";
        pager = "delta --dark";
        whitespace = "trailing-space,space-before-tab";
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      delta = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    historyWidgetOptions = [
      "--sort"
    ];
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
    historyLimit = 100000;
    shell = "${pkgs.zsh}/bin/zsh";
    #newSession = true;
    #escapeTime = 0;
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'frappe'
          set -g @catppuccin_window_tabs_enabled on
          set -g @catppuccin_date_time "%H:%M"
        '';
      }
    ];
    extraConfig = ''
      set-option -g mouse on
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g allow-passthrough on
      set -as terminal-features ',linux:clipboard'
    '';
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font.name = "Terminus (TTF)";
    font.size = 12;
    themeFile = "SpaceGray_Eighties";
    extraConfig = ''
      shell_integration enabled
      shell zsh
      editor .
      tab_bar_edge top
      tab_bar_style powerline
      tab_switch_strategy right
      #tab_title_template " {index}: {f'{title[:6]}…{title[-6:]}' if title.rindex(title[-1]) + 1 > 13 else title.center(7)}"
      #tab_title_template "{index}: {title[title.rfind('/')+1:]}"
      tab_title_template " {index}: {f'…{title[-14:]}' if title.rindex(title[-1]) + 1 > 15 else title.center(10)}"
      active_tab_font_style bold
      tab_bar_margin_width 6
      tab_powerline_style round
      tab_separator " ┇"
      macos_option_as_alt yes
      map alt+1 goto_tab 1
      map alt+2 goto_tab 2
      map alt+3 goto_tab 3
      map alt+4 goto_tab 4
      map alt+5 goto_tab 5
      map alt+6 goto_tab 6
      map alt+7 goto_tab 7
      map alt+8 goto_tab 8
      map alt+9 goto_tab 9
      map alt+t new_tab_with_cwd
      map alt+w close_tab
      map alt+q close_os_window
      map shift+h previous_tab
      map shift+l next_tab
      #map cmd+c copy_to_clipboard
      map ctrl+c copy_and_clear_or_interrupt
      #map cmd+v paste_from_clipboard
      map ctrl+v paste_from_clipboard
    '';
  };

  #programs.wezterm = { #62 lines
  #enable = true;
  #enableZshIntegration = true;
  #extraConfig = ''
  #local wezterm = require 'wezterm'
  #local my_framer = wezterm.color.get_builtin_schemes()['Framer (base16)']
  #my_framer.cursor_fg = '#181818'
  #my_framer.cursor_bg = '#EEEEEE'
  #my_framer.compose_cursor = '#20BCFC'
  #local mux = wezterm.mux
  #wezterm.on('gui-startup', function()
  #local tab, pane, window = mux.spawn_window(cmd or {})
  #window:gui_window():maximize()
  #end)
  #local gpus = wezterm.gui.enumerate_gpus()
  #local act = wezterm.action
  #return {
  #font_size = 12,
  #--font = wezterm.font('FiraCode Nerd Font Mono', { weight = 'Light', }),
  #--font = wezterm.font('FiraCode Nerd Font Mono'),
  #--font = wezterm.font('Terminus'),
  #--font = wezterm.font("MesloLGS NF"),
  #font = wezterm.font('Ttyp0'),
  #--font = wezterm.font('System'),
  #webgpu_preferred_adapter = gpus[1],
  #--front_end = "WebGpu",
  #front_end = "OpenGL",
  #enable_wayland = false,
  #webgpu_force_fallback_adapter = true,
  #webgpu_power_preference = "HighPerformance",
  #window_background_opacity = 1,
  #hide_tab_bar_if_only_one_tab = true,
  #default_cursor_style = "SteadyBar",
  #cursor_blink_rate = 600,
  #default_prog = { "zsh" },
  #window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
  #window_decorations = "NONE",
  #use_fancy_tab_bar = false,
  #adjust_window_size_when_changing_font_size = false,
  #inactive_pane_hsb = { saturation = 1, brightness = 1 }, -- s0.9, b0.8
  #color_schemes = { ['My Framer'] = my_framer, },
  #color_scheme = 'My Framer',
  #keys = {
  #{ key = 't', mods = 'CMD|SHIFT', action = act.SpawnTab 'CurrentPaneDomain', },
  #--{ key = 't', mods = 'CMD', action = act.SpawnTab 'CurrentPaneDomain', },
  #{ key = 'l', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(1) },
  #{ key = 'h', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(-1) },
  #{ key = '1', mods = 'ALT',       action = act.ActivateTab(0) },
  #{ key = '2', mods = 'ALT',       action = act.ActivateTab(1) },
  #{ key = '3', mods = 'ALT',       action = act.ActivateTab(2) },
  #{ key = '4', mods = 'ALT',       action = act.ActivateTab(3) },
  #{ key = '5', mods = 'ALT',       action = act.ActivateTab(4) },
  #{ key = '6', mods = 'ALT',       action = act.ActivateTab(5) },
  #{ key = '7', mods = 'ALT',       action = act.ActivateTab(6) },
  #{ key = '8', mods = 'ALT',       action = act.ActivateTab(7) },
  #{ key = '9', mods = 'ALT',       action = act.ActivateTab(8) },
  #--{ key = 'c', mods = 'CMD', action = act.CopyTo 'Clipboard' },
  #--{ key = 'v', mods = 'CMD', action = act.PasteFrom 'Clipboard' },
  #}
  #}
  #'';
  #};

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs"; # others don't work as good as this
    shellAliases = {
      proxychains = "proxychains4";
      ll = "ls -l";
      iu = "cd /storage/immich-app && docker compose pull && docker compose up -d";
      y7 = "(){ yt-dlp -f 137+140 --no-mtime $1. ;}";
      y6 = "(){ yt-dlp -f 136+140 --no-mtime $1. ;}";
      y67 = "(){ yt-dlp -f '137+140/136+140' --no-mtime $1. ;}";
      yfm = "(){ yt-dlp --list-formats $1. ;}";
      yab = "(){ yt-dlp --no-mtime -f 'bestvideo+bestaudio' $1. ;}";
      #ys = "(){ yt-dlp --write-sub --write-auto-sub --sub-lang 'en-US,en-GB,en,en.*' --convert-subtitles srt --skip-download $1. ;}";
      #y = "(){ yt-dlp --write-sub --sub-lang 'en.*' --convert-subtitles srt -f '299+140/137+140/136+140/135+140/134+140/299+140-8/299+140-7/299+140-6/299+140-5/299+140-4/299+140-3/299+140-2/299+140-1/137+140-8/137+140-7/137+140-6/137+140-5/137+140-4/137+140-3/137+140-2/137+140-1/136+140-8/136+140-7/136+140-6/136+140-5/136+140-4/136+140-3/136+140-2/136+140-1' --no-mtime $1. ;}";
      y = "(){ ~/python/yt-dlp --path /storage/myfiles/youtube --cookies-from-browser firefox -vU --write-sub --sub-lang 'en.*' --convert-subtitles srt -f '299+140/137+140/136+140/135+140/134+140/299+140-22/299+140-21/299+140-20/299+140-19/299+140-18/299+140-17/299+140-16/299+140-15/299+140-14/299+140-13/299+140-12/299+140-11/299+140-10/299+140-9/299+140-8/299+140-7/299+140-6/299+140-5/299+140-4/299+140-3/299+140-2/299+140-1/137+140-22/137+140-21/137+140-20/137+140-19/137+140-18/137+140-17/137+140-16/137+140-15/137+140-14/137+140-13/137+140-12/137+140-11/137+140-10/137+140-9/137+140-8/137+140-7/137+140-6/137+140-5/137+140-4/137+140-3/137+140-2/137+140-1/136+140-10/136+140-9/136+140-8/136+140-7/136+140-6/136+140-5/136+140-4/136+140-3/136+140-2/136+140-1' --no-mtime --no-check-certificate $1. ;}";
      yc = "(){ ~/python/yt-dlp --path /storage/myfiles/youtube --cookies /storage/myfiles/youtube/cookie.txt -vU --write-sub --sub-lang 'en.*' --convert-subtitles srt -f '299+140/137+140/136+140/135+140/134+140/299+140-22/299+140-21/299+140-20/299+140-19/299+140-18/299+140-17/299+140-16/299+140-15/299+140-14/299+140-13/299+140-12/299+140-11/299+140-10/299+140-9/299+140-8/299+140-7/299+140-6/299+140-5/299+140-4/299+140-3/299+140-2/299+140-1/137+140-22/137+140-21/137+140-20/137+140-19/137+140-18/137+140-17/137+140-16/137+140-15/137+140-14/137+140-13/137+140-12/137+140-11/137+140-10/137+140-9/137+140-8/137+140-7/137+140-6/137+140-5/137+140-4/137+140-3/137+140-2/137+140-1/136+140-10/136+140-9/136+140-8/136+140-7/136+140-6/136+140-5/136+140-4/136+140-3/136+140-2/136+140-1' --no-mtime --no-check-certificate $1. ;}";
      ybc = "(){ ~/python/yt-dlp --path /storage/myfiles/youtube --cookies /storage/myfiles/youtube/cookie.txt  -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' --no-mtime --merge-output-format mp4 --write-sub --sub-lang 'en.*' --convert-subtitles srt -vU $1. ;}";
      yh = "(){ ~/python/yt-dlp --cookies-from-browser firefox -vU --write-sub --sub-lang 'en.*' --convert-subtitles srt -f '299+140/137+140/136+140/135+140/134+140/299+140-12/299+140-11/299+140-10/299+140-9/299+140-8/299+140-7/299+140-6/299+140-5/299+140-4/299+140-3/299+140-2/299+140-1/137+140-12/137+140-11/137+140-10/137+140-9/137+140-8/137+140-7/137+140-6/137+140-5/137+140-4/137+140-3/137+140-2/137+140-1/136+140-10/136+140-9/136+140-8/136+140-7/136+140-6/136+140-5/136+140-4/136+140-3/136+140-2/136+140-1' --no-mtime --no-check-certificate $1. ;}";
      yb = "(){ ~/python/yt-dlp --path /storage/myfiles/youtube --cookies-from-browser firefox -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' --no-mtime --merge-output-format mp4 --write-sub --sub-lang 'en.*' --convert-subtitles srt -vU $1. ;}";
      yhere = "(){ ~/python/yt-dlp --cookies-from-browser firefox -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' --no-mtime --merge-output-format mp4 --write-sub --sub-lang 'en.*' --convert-subtitles srt -vU $1. ;}";
      yo = "(){ ~/python/yt-dlp --path /storage/myfiles/youtube --cookies-from-browser firefox -vU --write-sub --sub-lang 'en.*' --convert-subtitles srt -f '299+140/137+140/136+140/135+140/134+140/299+140-12/299+140-11/299+140-10/299+140-9/299+140-8/299+140-7/299+140-6/299+140-5/299+140-4/299+140-3/299+140-2/299+140-1/137+140-12/137+140-11/137+140-10/137+140-9/137+140-8/137+140-7/137+140-6/137+140-5/137+140-4/137+140-3/137+140-2/137+140-1/136+140-12/136+140-11/136+140-10/136+140-9/136+140-8/136+140-7/136+140-6/136+140-5/136+140-4/136+140-3/136+140-2/136+140-1' --no-mtime --no-check-certificate $1. ;}";
      a = "(){ ~/python/yt-dlp --path /storage/myfiles/youtube --cookies-from-browser firefox -f 'bestaudio' --extract-audio --audio-format mp3 --no-check-certificate $1. ;}";
      sp = "(){ cd ~/python/spotdl && spotdl --output '/storage/myfiles/Music/{artist}_{year}_{album}/{track-number} - {title}.{output-ext}' --yt-dlp-args '--cookies-from-browser firefox' $1. ;}";
      s = "(){ spotdl --output '/storage/myfiles/Music//{artist}_{year}_{album}/{track-number} - {title}.{output-ext}' --yt-dlp-args '--cookies-from-browser firefox' $1. ;}";
      ys = "(){ ~/python/yt-dlp --path /storage/myfiles/youtube --cookies-from-browser firefox -vU --write-sub --write-auto-sub --sub-lang 'en-US,en-GB,en,en.*' --convert-subtitles srt --skip-download --no-check-certificate $1. ;}";
      yshere = "(){ ~/python/yt-dlp --cookies-from-browser firefox -vU --write-sub --write-auto-sub --sub-lang 'en-US,en-GB,en,en.*' --convert-subtitles srt --skip-download --no-check-certificate $1. ;}";
      yv = "(){ yt-dlp -f '299+140/137+140/136+140/135+140/134+140/299+140-8/299+140-7/299+140-6/299+140-5/299+140-4/299+140-3/299+140-2/299+140-1/137+140-8/137+140-7/137+140-6/137+140-5/137+140-4/137+140-3/137+140-2/137+140-1/136+140-8/136+140-7/136+140-6/136+140-5/136+140-4/136+140-3/136+140-2/136+140-1' --no-mtime --no-check-certificate $1. ;}";
      sa = "(){ spotdl --output '{artist}_{year}_{album}/{track-number} - {title}.{output-ext}' $1. ;}";
      #v2a = "find . -maxdepth 1 -type f \\( -iname \"*.mp4\" -o -iname \"*.mkv\" -o -iname \"*.mov\" \\) -exec sh -c 'for f; do ffmpeg -i \"$f\" -q:a 0 -map a \"\${f%.*}.mp3\"; done' _ {} +";
      v2a = "find . -maxdepth 1 -type f \\( -iname \"*.mp4\" -o -iname \"*.mkv\" -o -iname \"*.mov\" \\) -exec sh -c 'for f; do out=\"\${f%.*}.mp3\"; [ -f \"$out\" ] || ffmpeg -i \"$f\" -q:a 0 -map a \"$out\"; done' _ {} +";
      srt2lrc = "for f in *.srt; do ~/python/subtitle-to-lrc_linux-amd64/subtitle-to-lrc \"$f\"; done";
      #bl = "sudo python3 ~/Downloads/osx_battery_charge_limit/main.py -s 42";
      #bh = "sudo python3 ~/Downloads/osx_battery_charge_limit/main.py -s 77";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./dotfiles/p10k-config;
        file = ".p10k.zsh";
      }
    ];
    initContent = builtins.readFile ./dotfiles/.zshrc;
    #envExtra= builtins.readFile ./dotfiles/.zshenv;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "z"
        "command-not-found"
        "poetry"
        "sudo"
        "terraform"
        "systemadmin"
      ];
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    withPython3 = true;
    extraConfig = ''
      colorscheme gruvbox
      filetype plugin indent on
      syntax enable
      set mouse=a
      set number
      set wrap
      set linebreak
      set clipboard=unnamed
      set nu rnu
      let &scrolloff = 5
      nn <F7> :setlocal spell! spell?<CR>
      nn <A-s> :setlocal spell! spell?<CR>
      autocmd Filetype lua setlocal tabstop=4
      autocmd Filetype lua setlocal shiftwidth=4
      cnoremap <C-a> <Home>
      cnoremap <C-e> <End>
      cnoremap <C-p> <Up>
      cnoremap <C-n> <Down>
      cnoremap <C-b> <Left>
      cnoremap <C-f> <Right>
      cnoremap <C-d> <Del>
      cnoreabbrev <expr> tn getcmdtype() == ":" && getcmdline() == 'tn' ? 'tabnew' : 'tn'
      cnoreabbrev <expr> th getcmdtype() == ":" && getcmdline() == 'th' ? 'tabp' : 'th'
      cnoreabbrev <expr> tl getcmdtype() == ":" && getcmdline() == 'tl' ? 'tabn' : 'tl'
      cnoreabbrev <expr> te getcmdtype() == ":" && getcmdline() == 'te' ? 'tabedit' : 'te'
      lua vim.opt.signcolumn = "yes"
      lua vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]])
      lua vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]])
      lua vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]])
      lua vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]])
      autocmd Filetype python map <silent> <A-r> :w<CR>:terminal python3 % -m pdb<CR>:startinsert<CR>
      autocmd Filetype python map! <silent> <A-r> <ESC> :w<CR>:terminal python3 % -m pdb<CR>:startinsert<CR>
      autocmd Filetype python map <silent> <F5> :w<CR>:terminal python3 % -m pdb<CR>:startinsert<CR>
      autocmd Filetype python map! <silent> <F5> <ESC> :w<CR>:terminal python3 % -m pdb<CR>:startinsert<CR>
      autocmd FileType python map <silent> <leader>b oimport ipdb; ipdb.set_trace()<esc>
      autocmd FileType python map <silent> <leader>B obreakpoint()<esc>
      autocmd Filetype tex,latex map <A-r> :w <Enter> <localleader>lk<localleader>ll
      autocmd Filetype tex,latex map! <A-r> <ESC> :w <Enter> <localleader>lk<localleader>ll
      autocmd Filetype tex,latex map <F5> :w <Enter> <localleader>lk<localleader>ll
      autocmd Filetype tex,latex map! <F5> <ESC> :w <Enter> <localleader>lk<localleader>ll
      autocmd Filetype tex,latex map <A-e> <localleader>le
      autocmd Filetype tex,latex map! <A-e> <ESC> <localleader>le
      autocmd Filetype tex,latex map <F4> <localleader>le
      autocmd Filetype tex,latex map! <F4> <ESC> <localleader>le
      autocmd Filetype tex,latex set shiftwidth=4
      autocmd Filetype markdown map <silent> <A-r> :w<CR>:MarkdownPreview<CR>
      autocmd Filetype markdown map! <silent> <A-r> <ESC> :w<CR>:MarkdownPreview<CR>
      autocmd Filetype markdown map <silent> <F5> :w<CR>:MarkdownPreview<CR>
      autocmd Filetype markdown map! <silent> <F5> <ESC> :w<CR>:MarkdownPreview<CR>
      map [b :bprevious<CR>
      map ]b :bnext<CR>
      map qb :Bdelete<CR>
      lua vim.keymap.set("n", "H", [[<cmd>bprevious<cr>]])
      lua vim.keymap.set("n", "L", [[<cmd>bnext<cr>]])
      if has("autocmd")
        au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
      endif
      autocmd FileType css setlocal tabstop=2 shiftwidth=2
      autocmd FileType haskell setlocal tabstop=2 shiftwidth=2
      autocmd FileType nix setlocal tabstop=2 shiftwidth=2
      autocmd FileType json setlocal tabstop=2 shiftwidth=2
      autocmd FileType cpp setlocal tabstop=2 shiftwidth=2
      autocmd FileType c setlocal tabstop=2 shiftwidth=2
      autocmd FileType java setlocal tabstop=4 shiftwidth=4
      autocmd FileType markdown setlocal spell
      autocmd FileType markdown setlocal tabstop=2 shiftwidth=2
      au BufRead,BufNewFile *.wiki setlocal textwidth=80 spell tabstop=2 shiftwidth=2
      autocmd FileType xml setlocal tabstop=2 shiftwidth=2
      autocmd FileType help wincmd L
      autocmd FileType gitcommit setlocal spell
    '';
    #let g:airline#extensions#tabline#enabled = 1
    #let g:airline#extensions#tabline#switch_buffers_and_tabs = 0
    #if !exists('g:airline_symbols')
    #let g:airline_symbols = {}
    #endif
    #let g:airline_left_sep = ''
    #let g:airline_left_alt_sep = ''
    #let g:airline_right_sep = ''
    #let g:airline_right_alt_sep = ''
    #let g:airline_symbols.branch = ''
    #let g:airline_symbols.colnr = ' ℅:'
    #let g:airline_symbols.readonly = ''
    #let g:airline_symbols.linenr = ' :'
    #let g:airline_symbols.maxlinenr = '☰ '
    #let g:airline_symbols.dirty='⚡'
    plugins = with pkgs.vimPlugins; [
      #copilot-vim
      vim-visual-multi
      gruvbox
      trouble-nvim
      vim-nix
      nerdcommenter
      markdown-preview-nvim
      vim-bbye
      tmux-nvim
      #{
      #plugin = zk-nvim;
      #type = "lua";
      #config = ''
      #require("zk").setup({
      #-- can be "telescope", "fzf", "fzf_lua" or "select" (`vim.ui.select`)
      #-- it's recommended to use "telescope", "fzf" or "fzf_lua"
      #picker = "telescope",
      #lsp = {
      #-- `config` is passed to `vim.lsp.start_client(config)`
      #config = {
      #cmd = { "zk", "lsp" },
      #name = "zk",
      #-- on_attach = ...
      #-- etc, see `:h vim.lsp.start_client()`
      #},
      #-- automatically attach buffers in a zk notebook that match the given filetypes
      #auto_attach = {
      #enabled = true,
      #filetypes = { "markdown" },
      #},
      #},
      #})
      #'';
      #}
      #vim-airline
      #vim-airline-themes
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require('nvim-treesitter').setup({
            highlight = {
              enable = true,
              --disable = { "latex" },
            },
            indent = { enable = true},
          })
        '';
      }
      #nui-nvim
      #nvim-notify
      #{
      #plugin = noice-nvim;
      #type = "lua";
      #config = builtins.readFile(./neovim/noice.lua);
      #}
      {
        plugin = nvim-osc52;
        type = "lua";
        config = builtins.readFile (./neovim/osc52.lua);
      }
      {
        plugin = nvim-web-devicons;
        type = "lua";
        config = ''
          require("nvim-web-devicons").setup()
        '';
      }
      {
        plugin = fzf-lua;
        type = "lua";
        config = ''
          -- require("fzf-lua").setup({})
          -- require('fzf-lua').setup({'fzf-native'})
          -- vim.keymap.set("n", "<c-P>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
          -- require"fzf-lua".setup({"telescope",winopts={preview={default="bat"}}})
          require('fzf-lua').setup({'fzf-vim'})
        '';
      }
      #{
      #plugin = nvim-tree-lua;
      #type = "lua";
      #config = builtins.readFile(./neovim/nvimtree.lua);
      #}
      {
        plugin = lualine-nvim;
        type = "lua";
        config = builtins.readFile (./neovim/lualine.lua);
      }
      #{
      #plugin = bufferline-nvim;
      #type = "lua";
      #config = ''
      #vim.opt.termguicolors = true
      #require("bufferline").setup{}
      #'';
      #}
      {
        plugin = vimtex;
        config = # vim
          ''
            "let g:vimtex_view_general_method='qpdfview'
            let g:vimtex_view_method = 'zathura'
            "let g:vimtex_view_mupdf_send_keys = 'shift+h'
            "let g:vimtex_view_general_options = '-reuse-instance u/pdf'
            "let g:vimtex_view_general_viewer = 'okular'
            "let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
            "let g:vimtex_view_skim_activate=0
            "let g:vimtex_view_skim_reading_bar=1
            let g:vimtex_syntax_enabled=0
          '';
      }
      #{
      #plugin = vim-latex-live-preview;
      #config = # vim
      #''
      #let g:livepreview_previewer = 'zathura'
      #'';
      #}
      markdown-preview-nvim
      {
        plugin = vim-markdown;
        config = # vim
          ''
            let g:vim_markdown_folding_disabled = 1
            let g:vim_markdown_conceal = 0
            let g:vim_markdown_frontmatter = 1
            let g:vim_markdown_toml_frontmatter = 1
            let g:vim_markdown_json_frontmatter = 1
          '';
      }
      {
        plugin = nvim-lastplace;
        type = "lua";
        config = ''
          require('nvim-lastplace').setup()
        '';
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile (./neovim/lspconfig.lua);
      }
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lua
      #cmp-vsnip
      #vim-vsnip
      #friendly-snippets
      cmp-nvim-lsp
      lspkind-nvim
      {
        plugin = nvim-surround;
        type = "lua";
        config = ''
          require("nvim-surround").setup()
        '';
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile (./neovim/completion.lua);
      }
      plenary-nvim
      {
        plugin = mini-nvim;
        type = "lua";
        config = ''
          require('mini.trailspace').setup()
        '';
      }
      {
        plugin = harpoon2;
        type = "lua";
        config = builtins.readFile (./neovim/harpoon.lua);
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile (./neovim/telescope.lua);
      }
      telescope-file-browser-nvim
      telescope-ui-select-nvim
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
          require('ibl').setup({
            indent = {
              char = "┊",
            },
            scope = {
              enabled = true,
              show_start = true,
              show_end = true,
            },
          })
        '';
      }
      {
        plugin = treesj;
        type = "lua";
        config = ''
          require('treesj').setup{
            lang = {
                lua = require('treesj.langs.lua'),
                typescript = require('treesj.langs.typescript'),
                python = require('treesj.langs.python'),
              },
            use_default_keymaps = true,
            check_syntax_error = true,
            max_join_length = 120,
            cursor_behavior = 'hold',
            notify = true,
            dot_repeat = true,
            on_error = nil,
            }
        '';
      }
      nvim-dap
      #{
      #plugin = nvim-dap-python;
      #type = "lua";
      #config = builtins.readFile(./neovim/debuggerpy.lua);
      #}
      telescope-dap-nvim
      nvim-dap-ui
      neodev-nvim
      nvim-dap-virtual-text
    ];
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        "TERM" = "xterm-256color";
      };
      window = {
        #padding.x = 10;
        #padding.y = 10;
        dynamic_padding = true;
        opacity = 1;
        decorations = "None";
        startup_mode = "Maximized";
      };
      font = {
        size = 14;
        #normal.family = "JetbrainsMono Nerd Font";
        #bold.family = "JetbrainsMono Nerd Font";
        #italic.family = "JetbrainsMono Nerd Font";
        #normal.family = "Hack Nerd Font Mono";
        #bold.family = "Hack Nerd Font Mono";
        #italic.family = "Hack Nerd Font Mono";
        #normal.family = "terminus";
        #bold.family = "terminus";
        #italic.family = "terminus";
        #normal.family = "gohufont";
        #bold.family = "gohufont";
        #italic.family = "gohufont";
        normal.family = "Ttyp0";
        bold.family = "Ttyp0";
        italic.family = "Ttyp0";
      };
      cursor = {
        style.shape = "Beam";
        style.blinking = "On";
      };
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      terminal = {
        shell = {
          program = "zsh";
          args = [
            "-l"
          ];
        };
      };
      colors = {
        primary = {
          background = "0x1b182c";
          foreground = "0xcbe3e7";
        };
        normal = {
          black = "0x100e23";
          red = "0xff8080";
          green = "0x95ffa4";
          yellow = "0xffe9aa";
          blue = "0x91ddff";
          magenta = "0xc991e1";
          cyan = "0xaaffe4";
          white = "0xcbe3e7";
        };
        bright = {
          black = "0x565575";
          red = "0xff5458";
          green = "0x62d196";
          yellow = "0xffb378";
          blue = "0x65b2ff";
          magenta = "0x906cff";
          cyan = "0x63f2f1";
          white = "0xa6b3cc";
        };
      };
      keyboard = {
        bindings = [
          {
            key = "Q";
            mods = "Control";
            action = "Quit";
          }
        ];
      };
    };
  };

  #home.activation = mkIf pkgs.stdenv.isDarwin {
  #copyApplications = let
  #apps = pkgs.buildEnv {
  #name = "home-manager-applications";
  #paths = config.home.packages;
  #pathsToLink = "/Applications";
  #};
  #in
  #lib.hm.dag.entryAfter ["writeBoundary"] ''
  #baseDir="$HOME/Applications/Home Manager Apps"
  #if [ -d "$baseDir" ]; then
  #rm -rf "$baseDir"
  #fi
  #mkdir -p "$baseDir"
  #for appFile in ${apps}/Applications/*; do
  #target="$baseDir/$(basename "$appFile")"
  #$DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
  #$DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
  #done
  #'';
  #};
}
