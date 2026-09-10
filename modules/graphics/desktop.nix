{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    (inputs.dms.nixosModules.dank-material-shell)
  ];

  environment.systemPackages = with pkgs; [
    (inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default)
    xwayland-satellite
  ];

  nixpkgs = {
    overlays = [ inputs.niri.overlays.niri ];
  };

  nix.settings = {
    substituters = [
      "https://niri.cachix.org"
    ];

    trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  # TODO: get rid of ai slop
  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
  };
  systemd.user.services.dms = {
    serviceConfig = {
      IOSchedulingClass = "best-effort";
      IOSchedulingPriority = 0;
      Nice = -20;
      OOMScoreAdjust = -1000;
      CPUSchedulingResetOnFork = false;
      Slice = "session.slice";
    };
  };
}
