let
  tseeley = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6eIhu9iBunU+qDWOhzlRl7ysd630O29jR6Zk0125da";

  # Host keys will be added after deployment via ssh-keyscan
  # server-mail = "ssh-ed25519 AAAA...";
  # server-services = "ssh-ed25519 AAAA...";

  allKeys = [ tseeley ];
in
{
  "stalwart-admin.age".publicKeys       = allKeys;
  "directus-secret.age".publicKeys      = allKeys;
  "directus-admin.age".publicKeys       = allKeys;
  "directus-db-password.age".publicKeys = allKeys;
  "umami-app-secret.age".publicKeys     = allKeys;
  "umami-db-password.age".publicKeys    = allKeys;
  "miniflux-admin.age".publicKeys       = allKeys;
  "miniflux-db-password.age".publicKeys = allKeys;
  "caddy-clients.age".publicKeys        = allKeys;
}
