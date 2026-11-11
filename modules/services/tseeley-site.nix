{ pkgs, ... }:
{
  users.users.deploy = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      ''
        command="${pkgs.rrsync}/bin/rrsync -wo /var/www/tseeley.com",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIApYO7aqlEme8FeUb1EPLzBOagx79CkmuISrqNx9rLEb gh-actions-tseeley
      ''
    ];
  };
  systemd.tmpfiles.rules = [ "d /var/www/tseeley.com 0755 deploy users -" ];
}
