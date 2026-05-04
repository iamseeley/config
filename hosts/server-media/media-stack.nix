{ config, pkgs, lib, ... }:
{
  users.groups.media = { };

  systemd.tmpfiles.rules = [
    "d /data                              0775 root   media -"
    "d /data/media                        2775 root   media -"
    "d /data/media/movies                 2775 root   media -"
    "d /data/media/tv                     2775 root   media -"
    "d /data/media/downloads              2775 root   media -"
    "d /data/media/downloads/complete     2775 root   media -"
    "d /data/media/downloads/tv           2775 root   media -"
    "d /data/media/downloads/movies       2775 root   media -"
    "d /data/media/downloads/incomplete   2775 root   media -"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
  };
  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";

  services.jellyfin = {
    enable = true;
    group = "media";
    openFirewall = false;
  };
  services.jellyseerr.enable = true;
  services.prowlarr.enable = true;
  services.sonarr = {
    enable = true;
    group = "media";
  };
  services.radarr = {
    enable = true;
    group = "media";
  };
  services.bazarr = {
    enable = true;
    group = "media";
  };
  services.qbittorrent = {
    enable = true;
    group = "media";
    openFirewall = false;
    webuiPort = 8083;
  };
  services.recyclarr.enable = true;

  users.users.jellyfin.extraGroups = [
    "media"
    "render"
    "video"
  ];
  users.users.sonarr.extraGroups = [ "media" ];
  users.users.radarr.extraGroups = [ "media" ];
  users.users.bazarr.extraGroups = [ "media" ];
  users.users.qbittorrent.extraGroups = [ "media" ];

  # Upstream NixOS modules pin UMask=0022; override so Bazarr (in the media
  # group) can drop sidecar subtitle files into directories the *arrs create.
  systemd.services.sonarr.serviceConfig.UMask = lib.mkForce "0002";
  systemd.services.radarr.serviceConfig.UMask = lib.mkForce "0002";
  systemd.services.bazarr.serviceConfig.UMask = lib.mkForce "0002";
  systemd.services.qbittorrent.serviceConfig.UMask = lib.mkForce "0002";

  age.secrets.tailscale-authkey.file = ../../secrets/tailscale-authkey.age;

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale-authkey.path;
  };

  # LAN access for the *arr / Jellyfin web UIs. Public access happens via
  # Tailscale through Caddy on server-services (no ports 80/443 here).
  networking.firewall.allowedTCPPorts = [
    5055   # jellyseerr
    6767   # bazarr
    7878   # radarr
    8083   # qbittorrent
    8096   # jellyfin
    8989   # sonarr
    9696   # prowlarr
  ];
}
