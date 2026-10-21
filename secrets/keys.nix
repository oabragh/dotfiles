rec {
  users = {
    oabragh-laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhdIivFObJDyj5j0JNQhq4P5gsIGkhpMnZKuUzlIa9L oabragh@laptop";
  };

  hosts = {
    laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKI/cLsVFkESc3ahIf+6rVLXkFEB78kDdKcH8ChLNkre root@laptop";
    server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKg5eLleDfGXoTz7nFhwXcnnA80dzSmLZGYc3vpnOuqJ root@server";
  };

  allHosts = [
    hosts.laptop
    hosts.server
    users.oabragh-laptop
  ];

  laptopOnly = [
    hosts.laptop
    users.oabragh-laptop
  ];

  serverOnly = [
    hosts.server
    users.oabragh-laptop
  ];

  radicle = {
    # did:key:z6MkkLFoQxiWH7noLrvDEiYFs4uVEye2W1H2UtN4zJhpijGs
    laptop-node = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdax43pE64WStL3fiIJamI+WqXiWqgk+p0mEwrFEDyY";

    # did:key:z6MknUx5zFKTEEnWfaVwWHGE7GshBez84K3gKH6t2DHCCrmb
    server-node = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHdMWeC00kWnh6YkeU0NS/yz9Oti06+reSzZG7l/E8Hm";
  };
}
