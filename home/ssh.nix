{ lib, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
        extraOptions = lib.optionalAttrs pkgs.stdenv.isDarwin {
          UseKeychain = "yes";
        };
      };
      "d2" = {
        user = "membrane";
        forwardAgent = true;
      };
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
      };
      "mk2" = {
        user = "thomas";
        forwardAgent = true;
      };
      "server-mail" = {
        hostname = "mail.seeley.me";
        user = "root";
      };
      "server-services" = {
        hostname = "5.161.198.149";
        user = "root";
      };
      "thinky" = {
        hostname = "192.168.0.74";
        user = "root";
      };
    };
  };
}
