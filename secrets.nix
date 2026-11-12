let
  tseeley = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6eIhu9iBunU+qDWOhzlRl7ysd630O29jR6Zk0125da";

  mail = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHG9nbvtDwrLf/fGjgP91ASaRQpEn/sRXrADSmXyTe98 root@stalwart";
  apps = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE2MDNj8XBzhpiGvpwJpisdnmnK+nFxqcpct120UnB1k";
  thinky = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSHuPMotIPKbHAs0bvnVjB1OepW0fKQtRsw00CUORtq";
in
{
  "secrets/stalwart-admin.age".publicKeys = [
    tseeley
    mail
  ];
  "secrets/umami-app-secret.age".publicKeys = [
    tseeley
    apps
  ];
  "secrets/umami-db-password.age".publicKeys = [
    tseeley
    apps
  ];
  "secrets/miniflux-admin.age".publicKeys = [
    tseeley
    apps
    thinky
  ];
  "secrets/miniflux-db-password.age".publicKeys = [
    tseeley
    apps
    thinky
  ];
}
