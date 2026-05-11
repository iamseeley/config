{ config, pkgs, ... }: {
  users.users.caddy = {
    isSystemUser = true;
    group = "caddy";
    home = "/var/lib/caddy";
    createHome = true;
  };
  users.groups.caddy = { };

  environment.etc."caddy/Caddyfile".text = ''
    cms.seeley.me {
      reverse_proxy localhost:8055
    }
    stats.seeley.me {
      reverse_proxy localhost:3000
    }
    bookmarks.seeley.me {
      reverse_proxy localhost:8080
    }
    feeds.seeley.me {
      reverse_proxy localhost:8081
    }
    jellyfin.seeley.me {
      reverse_proxy http://server-media:8096
    }
    request.seeley.me {
      reverse_proxy http://server-media:5055
    }
  '';

  systemd.services.caddy = {
    description = "Caddy web server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "network-online.target" ];
    wants = [ "network-online.target" ];
    reloadTriggers = [ config.environment.etc."caddy/Caddyfile".source ];
    serviceConfig = {
      ExecStart = "${pkgs.caddy}/bin/caddy run --config /etc/caddy/Caddyfile";
      ExecReload = "${pkgs.caddy}/bin/caddy reload --config /etc/caddy/Caddyfile --force";
      User = "caddy";
      Group = "caddy";
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      StateDirectory = "caddy";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
