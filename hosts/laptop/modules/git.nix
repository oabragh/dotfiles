{
  keys,
  ...
}:
{
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "oabragh";
        email = "oabragh@outlook.com";
        signingkey = keys.users.oabragh-laptop;
      };

      commit.gpgsign = true;
      tag.gpgsign = true;
      gpg.format = "ssh";

      push.autoSetupRemote = true;
      pull.rebase = true;
      fetch.prune = true;

      init.defaultBranch = "main";

      column.ui = "auto";
      branch.sort = "-committerdate";

      diff.colorMoved = "default";
      merge.conflictstyle = "zdiff3";
      rerere.enabled = true;
    };
  };
}
