{ pkgs, ... }:
let
  policies = builtins.toJSON {
    DnsOverHttpsMode = "off";

    TorDisabled = 1;
    BraveRewardsDisabled = 1;
    BraveAIChatEnabled = 0;
    BraveNewsDisabled = 1;
    BraveTalkDisabled = 1;
    BravePlaylistEnabled = 0;
    BraveSpeedreaderEnabled = 0;
    BraveWaybackMachineEnabled = 1;
    BraveP3AEnabled = 0;
    BraveStatsPingEnabled = 0;
    BraveVPNDisabled = 1;

    # TODO: policies ...
  };
in
{
  environment.systemPackages = [
    pkgs.brave
  ];

  environment.etc."brave/policies/managed/config.json".text = policies;
}
