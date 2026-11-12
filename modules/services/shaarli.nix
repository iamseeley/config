{ config, pkgs, ... }:
{
  imports = [ ./caddy.nix ];

  users.users.shaarli = {
    isSystemUser = true;
    group = "shaarli";
  };
  users.groups.shaarli = { };

  # data/config.json.php points its resource paths at these directories, since
  # the shaarli package itself is read-only in the nix store
  systemd.tmpfiles.rules = [
    "d /var/lib/shaarli 0750 shaarli shaarli -"
    "d /var/lib/shaarli/tmp 0750 shaarli shaarli -"
    "d /var/lib/shaarli/pagecache 0750 shaarli shaarli -"
    "Z /var/lib/shaarli/data - shaarli shaarli -"
    "Z /var/lib/shaarli/cache - shaarli shaarli -"
  ];

  services.phpfpm.pools.shaarli = {
    user = "shaarli";
    group = "shaarli";
    phpEnv.SHAARLI_CONFIG = "/var/lib/shaarli/data/config";
    settings = {
      "listen.owner" = "caddy";
      "listen.group" = "caddy";
      "pm" = "ondemand";
      "pm.max_children" = 4;
    };
  };

  services.caddy.virtualHosts."bookmarks.seeley.me".extraConfig = ''
    root * ${pkgs.shaarli}
    @blocked {
      path *.php
      not path /index.php
    }
    respond @blocked 404
    php_fastcgi unix/${config.services.phpfpm.pools.shaarli.socket}
    file_server
  '';
}
