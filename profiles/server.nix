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
  ];

  services.tailscale.enable = true;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
