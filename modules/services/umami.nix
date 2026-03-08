{ config, pkgs, ... }: {
  age.secrets.umami-app-secret.file   = ../../secrets/umami-app-secret.age;
  age.secrets.umami-db-password.file  = ../../secrets/umami-db-password.age;

  systemd.services.umami = {
    description = "Umami analytics";
    after    = [ "docker.service" "network.target" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker}/bin/docker compose -f /etc/umami/docker-compose.yml up";
      ExecStop  = "${pkgs.docker}/bin/docker compose -f /etc/umami/docker-compose.yml down";
      Restart = "always";
      EnvironmentFile = [
        config.age.secrets.umami-app-secret.path
        config.age.secrets.umami-db-password.path
      ];
    };
  };

  environment.etc."umami/docker-compose.yml".text = ''
    services:
      umami:
        image: ghcr.io/umami-software/umami:latest
        ports:
          - "3000:3000"
        environment:
          DATABASE_URL: ''${DATABASE_URL}
          APP_SECRET: ''${APP_SECRET}
        depends_on:
          db:
            condition: service_healthy
        init: true
        restart: always
        healthcheck:
          test: ["CMD-SHELL", "curl http://localhost:3000/api/heartbeat"]
          interval: 5s
          timeout: 5s
          retries: 5
      db:
        image: postgres:15-alpine
        environment:
          POSTGRES_DB: ''${POSTGRES_DB}
          POSTGRES_USER: ''${POSTGRES_USER}
          POSTGRES_PASSWORD: ''${POSTGRES_PASSWORD}
        volumes:
          - umami-db-data:/var/lib/postgresql/data
        restart: always
        healthcheck:
          test: ["CMD-SHELL", "pg_isready -U $${POSTGRES_USER} -d $${POSTGRES_DB}"]
          interval: 5s
          timeout: 5s
          retries: 5
    volumes:
      umami-db-data:
  '';
}
