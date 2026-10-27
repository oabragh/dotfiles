{ pkgs, ... }:
let
  footConfig = {
    main = {
      shell = "fish";
      term = "foot";
      login-shell = "no";
      font = "JetBrainsMonoNL NF:size=13";
      pad = "10x15 center-when-maximized-and-fullscreen";
      include = "~/.local/share/iris/themes/foot.ini";
    };

    cursor = {
      style = "block";
      blink = "no";
    };

    mouse = {
      hide-when-typing = "yes";
    };

    scrollback = {
      lines = 1500;
    };

    csd = {
      preferred = "server";
    };
  };
in
{
  environment.systemPackages = [
    pkgs.foot
  ];

  hjem.users.oabragh.files = {
    ".config/foot/foot.ini" = {
      generator = (pkgs.formats.ini { }).generate "foot.ini";
      value = footConfig;
    };
  };
}
