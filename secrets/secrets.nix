let
  keys = import ./keys.nix;
in
{
  "server/miniflux-admin.env.age".publicKeys = keys.serverOnly;
  "server/stalwart-admin.env.age".publicKeys = keys.serverOnly;
  "server/radicle.age".publicKeys = keys.serverOnly;
  "server/bulwark-session.age".publicKeys = keys.serverOnly;

  "laptop/radicle.age".publicKeys = keys.laptopOnly;
}
