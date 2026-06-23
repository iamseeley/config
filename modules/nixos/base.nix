{ config, pkgs, ... }:
let
  tseeleyKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6eIhu9iBunU+qDWOhzlRl7ysd630O29jR6Zk0125da tseeley@ts.local";
in
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "@wheel" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.tseeley = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ tseeleyKey ];
  };
  users.users.root.openssh.authorizedKeys.keys = [ tseeleyKey ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  networking.firewall.enable = true;
}
