{pkgs, ...}: {
  # Enable the git module
  programs.git = {
    enable = true;

    # User information
    userName = "/dev/marx";
    userEmail = "devmarx1989@gmail.com";

    # Aliases
    aliases = {
      st = "status";
      ls = "log --graph --decorate --oneline --all";
    };

    # Other Git configurations
    extraConfig = {
      # Core settings now go in here
      core.editor = "nvim";
      core.compression = 9;
      core.pager = "delta";
      core.autocrlf = "input";

      # Other settings remain in extraConfig
      interactive.diffFilter = "delta --color-only";
      credential.helper = "store";
      delta.navigate = "true";
      diff.colorMoved = "default";
      diff.algorithm = "patience";
      gc.aggressiveDepth = "4095";
      pull.rebase = "false";
      merge.conflictstyle = "diff3";
      init.defaultBranch = "main";
      push.autoSetupRemote = "true";
      lfs.allowincompletepush = "true";
    };

    # Enable git-lfs if you use it
    lfs.enable = true;
  };
}
