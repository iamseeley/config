{ config, ... }:
{
  age.secrets.umami-app-secret.file = ../../secrets/umami-app-secret.age;

  services.umami = {
    enable = true;
    settings = {
      APP_SECRET_FILE = config.age.secrets.umami-app-secret.path;
      DISABLE_TELEMETRY = true;
    };
  };
}
