{ config, pkgs, ... }: {
  age.secrets.miniflux-admin.file       = ../../secrets/miniflux-admin.age;
  age.secrets.miniflux-db-password.file = ../../secrets/miniflux-db-password.age;

  systemd.services.miniflux = {
    description = "Miniflux feed reader";
    after    = [ "docker.service" "network.target" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker}/bin/docker compose -f /etc/miniflux/docker-compose.yml up";
      ExecStop  = "${pkgs.docker}/bin/docker compose -f /etc/miniflux/docker-compose.yml down";
      Restart = "always";
      EnvironmentFile = [
        config.age.secrets.miniflux-admin.path
        config.age.secrets.miniflux-db-password.path
      ];
    };
  };

  environment.etc."miniflux/docker-compose.yml".text = ''
    services:
      miniflux:
        image: miniflux/miniflux:latest
        ports:
          - "8081:8080"
        environment:
          DATABASE_URL: postgres://miniflux:''${DB_PASSWORD}@db/miniflux?sslmode=disable
          RUN_MIGRATIONS: "1"
          CREATE_ADMIN: "1"
          ADMIN_USERNAME: ''${ADMIN_USERNAME}
          ADMIN_PASSWORD: ''${ADMIN_PASSWORD}
        depends_on:
          db:
            condition: service_healthy
        restart: unless-stopped
      db:
        image: postgres:16-alpine
        environment:
          POSTGRES_USER: miniflux
          POSTGRES_PASSWORD: ''${DB_PASSWORD}
          POSTGRES_DB: miniflux
        volumes:
          - db_data:/var/lib/postgresql/data
        healthcheck:
          test: ["CMD", "pg_isready", "-U", "miniflux"]
          interval: 10s
          retries: 5
        restart: unless-stopped
    volumes:
      db_data:
  '';
}
