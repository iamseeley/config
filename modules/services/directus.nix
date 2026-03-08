{ config, pkgs, ... }: {
  virtualisation.docker.enable = true;

  age.secrets.directus-secret.file      = ../../secrets/directus-secret.age;
  age.secrets.directus-admin.file        = ../../secrets/directus-admin.age;
  age.secrets.directus-db-password.file  = ../../secrets/directus-db-password.age;

  systemd.services.directus = {
    description = "Directus CMS";
    after    = [ "docker.service" "network.target" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker}/bin/docker compose -f /etc/directus/docker-compose.yml up";
      ExecStop  = "${pkgs.docker}/bin/docker compose -f /etc/directus/docker-compose.yml down";
      Restart = "always";
      EnvironmentFile = [
        config.age.secrets.directus-secret.path
        config.age.secrets.directus-admin.path
        config.age.secrets.directus-db-password.path
      ];
    };
  };

  environment.etc."directus/docker-compose.yml".text = ''
    services:
      database:
        image: postgres:16-alpine
        volumes:
          - db_data:/var/lib/postgresql/data
        environment:
          POSTGRES_USER: directus
          POSTGRES_PASSWORD: ''${DB_PASSWORD}
          POSTGRES_DB: directus
        restart: unless-stopped
      directus:
        image: directus/directus:latest
        ports:
          - "8055:8055"
        volumes:
          - uploads:/directus/uploads
          - extensions:/directus/extensions
        environment:
          SECRET: ''${DIRECTUS_SECRET}
          ADMIN_EMAIL: ''${ADMIN_EMAIL}
          ADMIN_PASSWORD: ''${ADMIN_PASSWORD}
          DB_CLIENT: "pg"
          DB_HOST: "database"
          DB_PORT: "5432"
          DB_DATABASE: "directus"
          DB_USER: "directus"
          DB_PASSWORD: ''${DB_PASSWORD}
          WEBSOCKETS_ENABLED: "true"
          CORS_ENABLED: "true"
          CORS_ORIGIN: "*"
        depends_on:
          - database
        restart: unless-stopped
    volumes:
      db_data:
      uploads:
      extensions:
  '';
}
