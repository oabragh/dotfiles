{
  pkgs,
  config,
  ...
}:
let
  cfg = config.sys;
  isLaptop = cfg.host.name == "machine";
in
{
  security = {
    rtkit.enable = isLaptop;
    polkit.enable = true;

    apparmor = {
      enable = true;
      killUnconfinedConfinables = isLaptop;
      packages = if isLaptop then [ pkgs.apparmor-profiles ] else [ ];
    };

    # TODO: consider doas
    sudo-rs = {
      enable = isLaptop;
      extraConfig = ''
        Defaults pwfeedback
      '';
    };
  };
}
