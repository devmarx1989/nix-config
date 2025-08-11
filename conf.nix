# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{lib, ...}:
with lib.hm.gvariant; {
  dconf.settings = {
    "app/drey/Elastic" = {
      last-language = "vala";
    };

    "org/gnome/Console" = {
      custom-font = "Monaspace Krypton Var 13";
      font-scale = 0.7999999999999999;
      ignore-scrollback-limit = true;
      last-window-maximised = false;
      last-window-size = mkTuple [953 503];
      theme = "day";
      use-system-font = false;
    };

    "org/gnome/TextEditor" = {
      last-save-directory = "file:///home/dev-marx/Nix/system";
    };

    "org/gnome/Weather" = {
      locations = [(mkVariant [(mkUint32 2) (mkVariant ["Guadalajara" "MMGL" true [(mkTuple [0.3580833906852675 (-1.803216011336572)])] [(mkTuple [0.36070138456325895 (-1.8035068879097094)])]])]) (mkVariant [(mkUint32 2) (mkVariant ["Guadalajara" "LETO" true [(mkTuple [0.7065674530312737 (-6.021385919380437e-2)])] [(mkTuple [0.7091920442538375 (-5.5281454007913275e-2)])]])])];
      window-height = 494;
      window-maximized = false;
      window-width = 439;
    };

    "org/gnome/baobab/ui" = {
      is-maximized = false;
      window-size = mkTuple [960 600];
    };

    "org/gnome/calculator" = {
      base = 10;
      button-mode = "programming";
      show-thousands = true;
      window-position = mkTuple [100 100];
      word-size = 64;
    };

    "org/gnome/clocks" = {
      world-clocks = [
        {
          location = mkVariant [(mkUint32 2) (mkVariant ["Guadalajara" "MMGL" true [(mkTuple [0.3580833906852675 (-1.803216011336572)])] [(mkTuple [0.36070138456325895 (-1.8035068879097094)])]])];
        }
      ];
    };

    "org/gnome/clocks/state/window" = {
      maximized = false;
      panel-id = "world";
      size = mkTuple [870 690];
    };

    "org/gnome/control-center" = {
      last-panel = "keyboard";
      window-state = mkTuple [980 640 false];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = ["System" "Utilities" "YaST" "Pardus"];
    };

    "org/gnome/desktop/app-folders/folders/Pardus" = {
      categories = ["X-Pardus-Apps"];
      name = "X-Pardus-Apps.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/System" = {
      apps = ["org.gnome.baobab.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Logs.desktop" "org.gnome.SystemMonitor.desktop"];
      name = "X-GNOME-Shell-System.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = ["org.gnome.Connections.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.font-viewer.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop"];
      name = "X-GNOME-Shell-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = ["X-SuSE-YaST"];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/map-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/map-d.svg";
      primary-color = "#241f31";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/input-sources" = {
      mru-sources = [(mkTuple ["xkb" "us"])];
      sources = [(mkTuple ["xkb" "us"]) (mkTuple ["xkb" "de"]) (mkTuple ["xkb" "latam"]) (mkTuple ["xkb" "jp"]) (mkTuple ["xkb" "ru"])];
      xkb-options = [];
    };

    "org/gnome/desktop/interface" = {
      accent-color = "red";
      color-scheme = "default";
      document-font-name = "MonaspiceXe Nerd Font 11";
      font-name = "MonaspiceAr Nerd Font 11";
      gtk-enable-primary-paste = true;
      monospace-font-name = "MonaspiceKr Nerd Font Mono 11";
    };

    "org/gnome/desktop/notifications" = {
      application-children = ["org-gnome-console" "firefox" "org-gnome-settings" "calibre-gui"];
    };

    "org/gnome/desktop/notifications/application/calibre-gui" = {
      application-id = "calibre-gui.desktop";
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-console" = {
      application-id = "org.gnome.Console.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-settings" = {
      application-id = "org.gnome.Settings.desktop";
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/map-l.svg";
      primary-color = "#241f31";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 900;
    };

    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "MonaspiceAr Nerd Font 11";
    };

    "org/gnome/epiphany" = {
      ask-for-default = false;
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [890 550];
      initial-size-file-chooser = mkTuple [890 550];
    };

    "org/gnome/portal/filechooser/lm-studio" = {
      last-folder-path = "/home/dev-marx/Drives/Drive/AI/Apps/lmstudio";
    };

    "org/gnome/portal/filechooser/microsoft-edge" = {
      last-folder-path = "/home/dev-marx/Documents";
    };

    "org/gnome/portal/filechooser/org/gnome/TextEditor" = {
      last-folder-path = "/home/dev-marx/Nix/home";
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = false;
      night-light-temperature = mkUint32 2097;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      disabled-extensions = ["rezmon@azz.lol"];
      enabled-extensions = ["System_Monitor@bghome.gmail.com" "monitor@astraext.github.io"];
      last-selected-power-profile = "power-saver";
      welcome-dialog-last-shown-version = "48.2";
    };

    "org/gnome/shell/extensions/astra-monitor" = {
      experimental-features = "[]";
      gpu-indicators-order = "[\"icon\",\"activity bar\",\"activity graph\",\"activity percentage\",\"memory bar\",\"memory graph\",\"memory percentage\",\"memory value\"]";
      headers-height = 0;
      headers-height-override = 0;
      memory-indicators-order = "[\"icon\",\"bar\",\"graph\",\"percentage\",\"value\",\"free\"]";
      monitors-order = "[\"processor\",\"gpu\",\"memory\",\"storage\",\"network\",\"sensors\"]";
      network-indicators-order = "[\"icon\",\"IO bar\",\"IO graph\",\"IO speed\"]";
      processor-indicators-order = "[\"icon\",\"bar\",\"graph\",\"percentage\",\"frequency\"]";
      processor-menu-gpu-color = "";
      profiles = ''
        {"default":{"panel-margin-left":0,"sensors-header-tooltip-sensor2-digits":-1,"memory-update":3,"gpu-header-memory-graph-color1":"rgba(29,172,214,1.0)","panel-box":"right","memory-header-show":true,"network-header-tooltip-io":true,"processor-header-bars-color2":"rgba(214,29,29,1.0)","processor-header-icon-size":18,"storage-source-storage-io":"auto","sensors-header-tooltip-sensor4-name":"","storage-header-icon-color":"","network-source-public-ipv4":"https://api.ipify.org","storage-header-io-graph-color2":"rgba(214,29,29,1.0)","storage-header-io":false,"processor-menu-top-processes-percentage-core":true,"sensors-header-sensor1":"\\"\\"","processor-header-graph":true,"storage-header-graph-width":30,"network-header-bars":false,"processor-source-load-avg":"auto","network-menu-arrow-color1":"rgba(29,172,214,1.0)","network-source-top-processes":"auto","gpu-header-icon":true,"processor-menu-graph-breakdown":true,"storage-ignored":"\\"[]\\"","sensors-header-icon-custom":"","sensors-header-sensor2":"\\"\\"","network-header-icon-alert-color":"rgba(235, 64, 52, 1)","memory-header-tooltip-free":false,"storage-header-io-figures":2,"network-menu-arrow-color2":"rgba(214,29,29,1.0)","sensors-header-tooltip-sensor3-name":"","network-source-public-ipv6":"https://api6.ipify.org","monitors-order":"\\"\\"","network-header-graph":true,"network-indicators-order":"\\"\\"","memory-header-percentage":false,"gpu-data":"\\"\\"","storage-header-bars":true,"processor-header-tooltip":true,"memory-menu-swap-color":"rgba(29,172,214,1.0)","storage-io-unit":"kB/s","memory-header-graph-width":30,"processor-header-graph-color1":"rgba(29,172,214,1.0)","sensors-header-tooltip-sensor5-digits":-1,"gpu-header-icon-custom":"","gpu-header-icon-size":18,"panel-margin-right":0,"processor-header-frequency":false,"processor-header-graph-breakdown":true,"sensors-header-tooltip-sensor3-digits":-1,"processor-source-cpu-usage":"auto","memory-header-value-figures":3,"compact-mode":false,"processor-header-frequency-mode":"average","panel-box-order":0,"compact-mode-compact-icon-custom":"","network-header-graph-width":30,"gpu-header-tooltip":true,"sensors-header-icon":true,"gpu-header-activity-percentage-icon-alert-threshold":0,"sensors-header-sensor2-digits":-1,"processor-header-graph-color2":"rgba(214,29,29,1.0)","sensors-header-icon-alert-color":"rgba(235, 64, 52, 1)","sensors-update":3,"gpu-header-tooltip-memory-value":true,"processor-header-bars":false,"gpu-header-tooltip-memory-percentage":true,"gpu-header-memory-bar-color1":"rgba(29,172,214,1.0)","sensors-header-tooltip-sensor1":"\\"\\"","sensors-header-tooltip-sensor1-digits":-1,"storage-header-free-figures":3,"processor-header-percentage-core":false,"sensors-header-tooltip-sensor2-name":"","network-source-network-io":"auto","memory-header-bars":true,"processor-header-percentage":false,"processor-header-frequency-figures":3,"storage-header-io-threshold":0,"memory-header-graph-color1":"rgba(29,172,214,1.0)","compact-mode-activation":"both","storage-header-icon-size":18,"sensors-header-tooltip-sensor1-name":"","sensors-header-icon-size":18,"sensors-header-icon-color":"","explicit-zero":false,"sensors-source":"auto","storage-header-io-graph-color1":"rgba(29,172,214,1.0)","storage-header-percentage-icon-alert-threshold":0,"sensors-header-tooltip-sensor2":"\\"\\"","compact-mode-expanded-icon-custom":"","memory-header-graph-color2":"rgba(29,172,214,0.3)","processor-header-icon-alert-color":"rgba(235, 64, 52, 1)","processor-header-tooltip-percentage":true,"gpu-header-show":false,"network-update":1.5,"sensors-header-tooltip-sensor3":"\\"\\"","sensors-ignored-attribute-regex":"","memory-header-icon-custom":"","storage-header-tooltip-io":true,"sensors-header-tooltip-sensor4":"\\"\\"","storage-header-percentage":false,"sensors-temperature-unit":"celsius","storage-header-icon-alert-color":"rgba(235, 64, 52, 1)","storage-header-free-icon-alert-threshold":0,"memory-source-top-processes":"auto","storage-header-value-figures":3,"storage-header-io-bars-color1":"rgba(29,172,214,1.0)","storage-menu-arrow-color1":"rgba(29,172,214,1.0)","gpu-header-tooltip-activity-percentage":true,"network-header-icon-custom":"","processor-header-graph-width":30,"network-header-icon":true,"storage-menu-arrow-color2":"rgba(214,29,29,1.0)","sensors-header-sensor2-layout":"vertical","sensors-header-tooltip-sensor5":"\\"\\"","memory-header-bars-breakdown":true,"sensors-header-show":false,"sensors-header-tooltip":false,"storage-header-tooltip":true,"processor-header-bars-core":false,"storage-indicators-order":"\\"\\"","processor-menu-bars-breakdown":true,"storage-header-io-bars-color2":"rgba(214,29,29,1.0)","network-io-unit":"kB/s","storage-header-icon":true,"gpu-header-activity-graph-color1":"rgba(29,172,214,1.0)","memory-unit":"kB-KB","processor-menu-core-bars-breakdown":true,"sensors-header-sensor2-show":false,"network-header-tooltip":true,"storage-header-tooltip-free":true,"storage-header-bars-color1":"rgba(29,172,214,1.0)","theme-style":"dark","storage-source-storage-usage":"auto","network-header-io":false,"storage-header-tooltip-value":false,"storage-main":"[default]","memory-header-tooltip-percentage":true,"memory-indicators-order":"\\"\\"","memory-source-memory-usage":"auto","memory-header-graph-breakdown":false,"memory-header-tooltip-value":true,"memory-menu-graph-breakdown":true,"sensors-indicators-order":"\\"\\"","compact-mode-start-expanded":false,"startup-delay":2,"memory-header-percentage-icon-alert-threshold":0,"sensors-header-sensor1-show":false,"network-ignored-regex":"","storage-update":3,"memory-header-value":false,"memory-header-bars-color1":"rgba(29,172,214,1.0)","network-header-io-graph-color1":"rgba(29,172,214,1.0)","gpu-header-memory-bar":true,"memory-used":"total-free-buffers-cached","gpu-header-memory-graph-width":30,"gpu-header-memory-graph":false,"sensors-ignored-category-regex":"","headers-font-family":"","memory-header-icon":true,"memory-header-bars-color2":"rgba(29,172,214,0.3)","network-header-io-graph-color2":"rgba(214,29,29,1.0)","processor-gpu":true,"network-header-icon-color":"","storage-header-value":false,"gpu-header-icon-alert-color":"rgba(235, 64, 52, 1)","processor-header-icon":true,"headers-font-size":0,"network-header-io-figures":2,"network-header-show":true,"sensors-ignored-regex":"","network-header-io-bars-color1":"rgba(29,172,214,1.0)","processor-update":1.5,"network-source-wireless":"auto","processor-indicators-order":"\\"\\"","storage-header-icon-custom":"","gpu-header-activity-bar":true,"gpu-header-activity-bar-color1":"rgba(29,172,214,1.0)","shell-bar-position":"top","network-ignored":"\\"[]\\"","network-header-io-bars-color2":"rgba(214,29,29,1.0)","memory-header-icon-color":"","sensors-header-sensor1-digits":-1,"storage-header-io-layout":"vertical","memory-header-icon-size":18,"network-header-io-threshold":0,"storage-header-show":true,"sensors-header-tooltip-sensor4-digits":-1,"processor-header-percentage-icon-alert-threshold":0,"memory-header-tooltip":true,"headers-height-override":0,"memory-header-graph":false,"network-header-icon-size":18,"gpu-header-icon-color":"","memory-header-free-figures":3,"processor-header-bars-breakdown":true,"gpu-header-activity-graph":false,"storage-header-io-bars":false,"memory-header-icon-alert-color":"rgba(235, 64, 52, 1)","storage-header-free":false,"processor-header-icon-custom":"","gpu-header-memory-percentage":false,"processor-header-tooltip-percentage-core":false,"processor-source-cpu-cores-usage":"auto","processor-source-top-processes":"auto","processor-header-icon-color":"","sensors-header-tooltip-sensor5-name":"","gpu-header-activity-graph-width":30,"gpu-header-activity-percentage":false,"gpu-indicators-order":"\\"\\"","network-header-io-layout":"vertical","gpu-update":2,"gpu-header-memory-percentage-icon-alert-threshold":0,"processor-header-bars-color1":"rgba(29,172,214,1.0)","processor-header-show":true,"storage-header-graph":false,"memory-header-free-icon-alert-threshold":0,"storage-ignored-regex":"","storage-menu-device-color":"rgba(29,172,214,1.0)","storage-header-tooltip-percentage":true,"memory-header-free":false,"storage-source-top-processes":"auto"}}
      '';
      sensors-indicators-order = "[\"icon\",\"value\"]";
      storage-indicators-order = "[\"icon\",\"bar\",\"percentage\",\"value\",\"free\",\"IO bar\",\"IO graph\",\"IO speed\"]";
      storage-main = "eui.0025385a0141c544-part2";
    };

    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = ["<Super>f"];
    };

    "org/gnome/shell/weather" = {
      automatic-location = true;
      locations = [(mkVariant [(mkUint32 2) (mkVariant ["Guadalajara" "MMGL" true [(mkTuple [0.3580833906852675 (-1.803216011336572)])] [(mkTuple [0.36070138456325895 (-1.8035068879097094)])]])]) (mkVariant [(mkUint32 2) (mkVariant ["Guadalajara" "LETO" true [(mkTuple [0.7065674530312737 (-6.021385919380437e-2)])] [(mkTuple [0.7091920442538375 (-5.5281454007913275e-2)])]])])];
    };

    "org/gnome/shell/world-clocks" = {
      locations = [(mkVariant [(mkUint32 2) (mkVariant ["Guadalajara" "MMGL" true [(mkTuple [0.3580833906852675 (-1.803216011336572)])] [(mkTuple [0.36070138456325895 (-1.8035068879097094)])]])])];
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = true;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 167;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-position = mkTuple [345 82];
      window-size = mkTuple [1231 902];
    };
  };
}
