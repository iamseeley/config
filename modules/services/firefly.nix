{ config, pkgs, ... }: {
  virtualisation.docker.enable = true;

  age.secrets.firefly-app-key.file    = ../../secrets/firefly-app-key.age;
  age.secrets.firefly-db-password.file = ../../secrets/firefly-db-password.age;

  systemd.services.firefly = {
    description = "Firefly III";
    after    = [ "docker.service" "network.target" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker}/bin/docker compose -f /etc/firefly/docker-compose.yml up";
      ExecStop  = "${pkgs.docker}/bin/docker compose -f /etc/firefly/docker-compose.yml down";
      Restart = "always";
      EnvironmentFile = [
        config.age.secrets.firefly-app-key.path
        config.age.secrets.firefly-db-password.path
      ];
    };
  };

  environment.etc."firefly/docker-compose.yml".text = ''
    services:
      database:
        image: postgres:16-alpine
        volumes:
          - db_data:/var/lib/postgresql/data
        environment:
          POSTGRES_USER: firefly
          POSTGRES_PASSWORD: ''${DB_PASSWORD}
          POSTGRES_DB: firefly
        restart: unless-stopped
      firefly:
        image: fireflyiii/core:latest
        ports:
          - "8082:8080"
        volumes:
          - upload:/var/www/html/storage/upload
        environment:
          APP_KEY: ''${APP_KEY}
          APP_URL: "https://finance.seeley.me"
          TRUSTED_PROXIES: "**"
          DB_CONNECTION: "pgsql"
          DB_HOST: "database"
          DB_PORT: "5432"
          DB_DATABASE: "firefly"
          DB_USERNAME: "firefly"
          DB_PASSWORD: ''${DB_PASSWORD}
        depends_on:
          - database
        restart: unless-stopped
      cron:
        image: alpine
        command: sh -c "echo '0 3 * * * wget -qO- http://firefly:8080/api/v1/cron/''${STATIC_CRON_TOKEN}' | crontab - && crond -f -L /dev/stdout"
        environment:
          STATIC_CRON_TOKEN: ''${APP_KEY}
        depends_on:
          - firefly
        restart: unless-stopped
    volumes:
      db_data:
      upload:
  '';
}
