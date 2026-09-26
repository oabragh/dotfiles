{ config, ... }:
{
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
    editor = false;
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = if (config.networking.hostName == "laptop") then 0 else 10;
  boot.initrd.verbose = false;

  # For emergencies
  boot.kernel.sysctl."kernel.sysrq" = 1;
}
