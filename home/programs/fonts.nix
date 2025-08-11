{fonts, ...}: {
  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    hinting = full;
    subpixelRendering = true;
    defaultFonts = {
      monospace = ["MonaspiceKr Nerd Font Mono"];
      sansSerif = ["MonaspiceAr Nerd Font"];
      serif = ["MonaspiceXe Nerd Font"];
    };
  };
}
