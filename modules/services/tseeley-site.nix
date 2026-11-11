{ pkgs, ... }:
{
  users.users.deploy = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      ''command="${pkgs.rrsync}/bin/rrsync -wo /var/www/tseeley.com",restrict SHA256:3j5lyeSmndY42I5DdFTz7f2pRYUHoB/bR1atnciRYm0 gh-actions-tseeley''
    ];
  };
  systemd.tmpfiles.rules = [ "d /var/www/tseeley.com 0755 deploy users -" ];
}
