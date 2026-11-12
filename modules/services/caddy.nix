{ ... }:
{
  # sites are declared by each service module via services.caddy.virtualHosts
  services.caddy.enable = true;

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
