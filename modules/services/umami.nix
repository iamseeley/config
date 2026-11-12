{ config, ... }:
{
  imports = [ ./caddy.nix ];

  age.secrets.umami-app-secret.file = ../../secrets/umami-app-secret.age;

  services.umami = {
    enable = true;
    settings = {
      APP_SECRET_FILE = config.age.secrets.umami-app-secret.path;
      DISABLE_TELEMETRY = true;
    };
  };

  services.caddy.virtualHosts."stats.seeley.me".extraConfig = ''
    reverse_proxy ${config.services.umami.settings.HOSTNAME}:${toString config.services.umami.settings.PORT}
  '';
}
