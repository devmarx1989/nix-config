{nix, ...}: {
  nix.settings = {
    max-jobs = "auto"; # Uses all available CPU cores
    cores = 0; # 0 means "use all cores" for individual build steps
    experimental-features = ["nix-command" "flakes"];
    use-sqlite-wal = true;
    trusted-users = ["root" "dev-marx"];
    auto-optimise-store = true;
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      # public key printed by `cachix use cuda-maintainers`
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];

    connect-timeout = 120;
    retry-attempts = 100;
    http-connections = 3;
  };
}
