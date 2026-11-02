let
  tseeley = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6eIhu9iBunU+qDWOhzlRl7ysd630O29jR6Zk0125da";

  server-mail = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHG9nbvtDwrLf/fGjgP91ASaRQpEn/sRXrADSmXyTe98 root@stalwart";
  server-services = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE2MDNj8XBzhpiGvpwJpisdnmnK+nFxqcpct120UnB1k";
  thinkcentre = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSHuPMotIPKbHAs0bvnVjB1OepW0fKQtRsw00CUORtq";
in
{
  "secrets/stalwart-admin.age".publicKeys = [
    tseeley
    server-mail
  ];
  "secrets/umami-app-secret.age".publicKeys = [
    tseeley
    server-services
  ];
  "secrets/umami-db-password.age".publicKeys = [
    tseeley
    server-services
  ];
  "secrets/miniflux-admin.age".publicKeys = [
    tseeley
    server-services
    thinkcentre
  ];
  "secrets/miniflux-db-password.age".publicKeys = [
    tseeley
    server-services
    thinkcentre
  ];
}
