{ pkgs, ... }: {
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };

    upower.enable = true;
    thermald.enable = true;
    power-profiles-daemon.enable = true;

    logind = {
      settings = {
        Login = {
          HandleLidSwitch = "suspend";
          HandleLidSwitchExternalPower = "ignore";
        };
      };
    };
  };

  hardware.bluetooth = {
    enable = true;

    powerOnBoot = false;

    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
}
