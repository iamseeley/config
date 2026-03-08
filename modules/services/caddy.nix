{ config, ... }: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "cms.seeley.me".extraConfig       = "reverse_proxy localhost:8055";
      "stats.seeley.me".extraConfig     = "reverse_proxy localhost:3000";
      "bookmarks.seeley.me".extraConfig = "reverse_proxy localhost:8080";
      "feeds.seeley.me".extraConfig     = "reverse_proxy localhost:8081";
    };
    extraConfig = ''
      import ${config.age.secrets.caddy-clients.path}
    '';
  };

  age.secrets.caddy-clients = {
    file = ../../secrets/caddy-clients.age;
    owner = "caddy";
  };
}
