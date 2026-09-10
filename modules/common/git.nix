{ config, ... }:
let
  cfg = config.sys;
in
{
  programs.git = {
    enable = true;
    config = {
      user = {
        name = cfg.git.userName;
        email = cfg.git.userEmail;
      };
      push = {
        autoSetupRemote = true;
        default = "simple";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
      color.ui = true;
      column.ui = "auto";
      rerere.enabled = true;
      branch.sort = "-committerdate";
      diff.colorMoved = "default";
      fetch.prune = true;
      help.autocorrect = 1;
      merge.conflictstyle = "zdiff3";
    };
  };
}
