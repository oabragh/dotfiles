{ config, ... }:
let
  cfg = config.sys;
in
{
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
    editor = false;
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = if (cfg.host.name == "machine") then 0 else 10;
  boot.initrd.verbose = false;

  # For emergencies
  boot.kernel.sysctl."kernel.sysrq" = 1;
}
