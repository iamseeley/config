{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../modules/nixos/base.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    htop
    docker-compose
  ];

  services.tailscale.enable = true;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
