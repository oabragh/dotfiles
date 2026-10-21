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
        signingkey = keys.radicle.laptop-node;
      };

      commit.gpgsign = true;
      tag.gpgsign = true;
      gpg.format = "ssh";

      push.autoSetupRemote = true;
      pull.rebase = true;
      fetch.prune = true;

      init.defaultBranch = "main";
      branch.sort = "-committerdate";
      merge.conflictstyle = "zdiff3";
    };
  };
}
