{ pkgs, ... }:
let
  policies = ''
    {
      "DnsOverHttpsMode": "off"
    }
  '';
in
{
  environment.systemPackages = [ pkgs.brave ];

  environment.etc."chromium/policies/managed/lockdown.json".text = policies;
  environment.etc."brave/policies/managed/lockdown.json".text = policies;
}
