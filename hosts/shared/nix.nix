{
  config,
  pkgs,
  inputs,
  ...
}:
let
  isLaptop = config.networking.hostName == "laptop";
  owner = "oabragh";
in
{
  nix = {
    # I have no reason to use lix but here we are
    package = pkgs.lix;

    gc.automatic = false;

    # So that my fans don't scream when i'm rebuilding
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    # Ensures that `nixpkgs` in, for example, `nix run nixpkgs#...`
    # matches this flake's nixpkgs
    registry.nixpkgs.flake = inputs.nixpkgs;

    # For legacy commands like nix-shell
    # Ensures <nixpkgs> matches this flake's nixpkgs
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

  nix.settings = {
    # Avoid duplicate items in store
    auto-optimise-store = true;

    # Keep going ✊🏻 i believe in you
    keep-going = true;

    # Ensures that dev shell packages aren't garbage collected
    # Enabling after i clean my disk a bit...
    # keep-outputs = true;

    experimental-features = [
      "flakes"
      "nix-command"
    ];

    builders-use-substitutes = true;

    substituters = [
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    trusted-users = [ "oabragh" ];
  };

  programs = {
    nix-ld.enable = isLaptop;

    nh = {
      # I think i only need it in laptop
      enable = isLaptop;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 5";
      flake = "/home/${owner}/Documents/Workspace/dotfiles";
    };

    appimage = {
      # Pulls a lot of gui deps, will not need in a server
      enable = isLaptop;
      binfmt = true;
    };

    direnv = {
      enable = isLaptop;
      settings = {
        whitelist = {
          prefix = [
            # Workspace directory is where things happens,
            # and i'd rather not to `direnv allow` all the time
            "/home/${owner}/Documents/Workspace/"
          ];
        };

        # Useless.
        warn_timeout = 0;
        hide_env_diff = true;
      };
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "x86_64-linux";
  };
}
