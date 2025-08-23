{pkgs, ...}: {
  home.packages = with pkgs; [
    qemu_full
    qemu-utils
    qemu-user
  ];
}
