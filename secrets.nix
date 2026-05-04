let
  tseeley = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6eIhu9iBunU+qDWOhzlRl7ysd630O29jR6Zk0125da";

  # Replace each null with the host's ssh-ed25519 pubkey after first deploy:
  #   ssh-keyscan SERVER_IP | grep ed25519
  # then run `agenix --rekey` from the repo root.
  server-mail = null;
  server-services = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP3DyhftfWvvkAll65DWt1XPFqNI8Mlta/nQoiciFq8L";
  server-media = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEetXXfIU5Yjqw9tSOvrqvMcFVvYaK1QP2aSmAO1uiUd";

  keys = builtins.filter (k: k != null);
in
{
  "secrets/stalwart-admin.age".publicKeys       = keys [ tseeley server-mail ];
  "secrets/directus-secret.age".publicKeys      = keys [ tseeley server-services ];
  "secrets/directus-admin.age".publicKeys       = keys [ tseeley server-services ];
  "secrets/directus-db-password.age".publicKeys = keys [ tseeley server-services ];
  "secrets/umami-app-secret.age".publicKeys     = keys [ tseeley server-services ];
  "secrets/umami-db-password.age".publicKeys    = keys [ tseeley server-services ];
  "secrets/miniflux-admin.age".publicKeys       = keys [ tseeley server-services ];
  "secrets/miniflux-db-password.age".publicKeys = keys [ tseeley server-services ];
  "secrets/tailscale-authkey.age".publicKeys    = keys [ tseeley server-media ];
  "secrets/mullvad-wg.conf.age".publicKeys      = keys [ tseeley server-media ];
  "secrets/restic-password.age".publicKeys      = keys [ tseeley server-media ];
  "secrets/restic-env.age".publicKeys           = keys [ tseeley server-media ];
}
