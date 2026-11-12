{ pkgs, inputs, ... }:
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts."origin.tseeley.com".extraConfig = ''
    root * ${inputs.tseeley-site.packages.${pkgs.stdenv.hostPlatform.system}.default}
    encode zstd gzip
    header Cache-Control "public, max-age=600, must-revalidate"
    file_server
    handle_errors 404 {
      rewrite * /404.html
      file_server
    }
  '';
}
