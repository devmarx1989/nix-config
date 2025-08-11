{programs, ...}: {
  programs.dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-enable-primary-paste = true;
      clock-show-seconds = true;
    };
  };
}
