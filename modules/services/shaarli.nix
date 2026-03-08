{ config, pkgs, ... }: {
  systemd.tmpfiles.rules = [
    "d /var/lib/shaarli/data  0777 root root -"
    "d /var/lib/shaarli/cache 0777 root root -"
  ];

  systemd.services.shaarli = {
    description = "Shaarli bookmarks";
    after    = [ "docker.service" "network.target" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker}/bin/docker compose -f /etc/shaarli/docker-compose.yml up";
      ExecStop  = "${pkgs.docker}/bin/docker compose -f /etc/shaarli/docker-compose.yml down";
      Restart = "always";
    };
  };

  environment.etc."shaarli/docker-compose.yml".text = ''
    services:
      shaarli:
        image: shaarli/shaarli:latest
        restart: unless-stopped
        ports:
          - "8080:80"
        volumes:
          - /var/lib/shaarli/cache:/var/www/shaarli/cache
          - /var/lib/shaarli/data:/var/www/shaarli/data
        environment:
          - TZ=America/Chicago
  '';
}
