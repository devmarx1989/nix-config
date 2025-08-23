{pkgs, ...}: {
  home.packages = with pkgs; [
    qemu
    qemu-utils
    qemu-user
  ];
}
