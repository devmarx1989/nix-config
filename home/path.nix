{pkgs, ...}: {
  home.sessionPath = [
    "$HOME/.rye/shims"
    "$HOME/.proto/shims"
    "$HOME/.cargo/bin"
    "$HOME/.ghcup/bin"
    "$HOME/.local/bin"
    "$HOME/.local/share/coursier/bin"
    "$HOME/.local/share/pnpm"
    "$HOME/.rye/shims"
    "$HOME/Bin"
    "$HOME/Go/bin"
    "$HOME/bin"
  ];
}
