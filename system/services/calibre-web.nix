{
  config,
  services,
  ...
}: let
  calibre = config.my.ports.calibreWeb;
in {
  services.calibre-web = {
    enable = true;
    user = "calibreWeb";
    group = "calibreWeb";
    options = {
      enableKepubify = true;
      enableBookUploading = true;
      enableBookConversion = true;
      calibreLibrary = "/drive/Libs/main";
    };
    listen = {
      ip = "0.0.0.0";
      port = calibre;
    };
  };
}
