{
  pkgs,
  config,
  inputs,
  ...
}:
let
  isLaptop = config.networking.hostName == "laptop";
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

  environment.systemPackages = [
    (inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default)
  ];

  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];
}
