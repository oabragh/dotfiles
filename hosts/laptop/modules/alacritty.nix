{
  pkgs,
  config,
  ...
}:
let
  alacrittyConfig = {
    general = {
      import = [
        "~/.local/share/iris/themes/alacritty.toml"
      ];
    };

    window = {
      decorations = "None";
      padding = {
        x = 10;
        y = 10;
      };
    };

    font = {
      normal = {
        family = "JetBrainsMonoNL NF";
      };
      size = 13;
    };

    terminal = {
      shell = "fish";
    };
  };
in
{
  environment.systemPackages = [
    pkgs.alacritty
  ];

  hjem.users.oabragh.files = {
    ".config/alacritty/alacritty.toml" = {
      generator = (pkgs.formats.toml { }).generate "alacritty.toml";
      value = alacrittyConfig;
    };
  };
}
