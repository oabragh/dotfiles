{
  services = {
    upower.enable = true;
    thermald.enable = true;
    power-profiles-daemon.enable = true;

    logind.settings = {
      Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "ignore";
      };
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
}
