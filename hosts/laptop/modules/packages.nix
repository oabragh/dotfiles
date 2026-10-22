inputs@{ pkgs, ... }:
let
  playground = import ../../../packages/playground.nix inputs;
in
{
  environment.systemPackages =
    with pkgs;
    [
      keepassxc
      zed-editor
      aseprite
      sioyek
      mpv
      android-tools
      brightnessctl
      wl-clipboard
      sherlock
      git-cliff
      yazi
      meli
      udiskie
      spotify
      obsidian
      playground
      rnote
      loupe
      nautilus
      foliate
    ];

  # temporally here
  programs.gpu-screen-recorder.enable = true;

  services.gnome.gcr-ssh-agent.enable = false;

  # TODO: implement in quickshell
  security.soteria.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  services.vdirsyncer.enable = true;
}
