{ config, ... }:
{
  imports = [ ./caddy.nix ];

  age.secrets.miniflux-admin.file = ../../secrets/miniflux-admin.age;

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.age.secrets.miniflux-admin.path;
    config.LISTEN_ADDR = "127.0.0.1:8081";
  };

  services.caddy.virtualHosts."feeds.seeley.me".extraConfig = ''
    reverse_proxy ${config.services.miniflux.config.LISTEN_ADDR}
  '';
}
