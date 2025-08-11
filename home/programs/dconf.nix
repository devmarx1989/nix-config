{
  dconf,
  lib,
  ...
}: {
  dconf.settings = {
    "org/gnome/calculator" = {
      button-mode = "programming";
      show-thousands = true;
      base = 10;
      word-size = 64;
      window-position = lib.hm.gvariant.mkTuple [100 100];
    };

    "org/gnome/desktop/interface" = {
      # UI font (menus, dialogs)
      font-name          = "MonaspiceAr Nerd Font 11";
      # Proportional document font (GTK apps that consult this)
      document-font-name = "MonaspiceXe Nerd Font 11";
      # Monospace font (terminals, code views)
      monospace-font-name = "MonaspiceKr Nerd Font Mono 11";
      gtk-enable-primary-paste = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      # Window title font
      titlebar-font = "MonaspiceAr Nerd Font 11";
    };
  };
}
