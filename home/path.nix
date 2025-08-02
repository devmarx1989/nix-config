{ pkgs, ... }:
{
  home.sessionPath = [
    "~/.rye/shims"
    "~/.proto/shims"
    "~/.cargo/bin"
    "~/.ghcup/bin"
    "~/.local/bin"
    "~/.local/share/coursier/bin"
    "~/.local/share/pnpm"
    "~/.rye/shims"
    "~/Bin"
    "~/Go/bin"
    "~/bin"
  ];
}
