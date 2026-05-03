{ config, pkgs, ... }: {
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
  services.sonarr  = { enable = true; group = "media"; };
  services.radarr  = { enable = true; group = "media"; };
  services.bazarr  = { enable = true; group = "media"; };
  services.sabnzbd = { enable = true; group = "media"; };

  # unpackerr: no upstream NixOS module in nixos-unstable yet.
  # Add a manual systemd unit post-boot once Sonarr/Radarr API keys exist.

  # recyclarr's full config (Sonarr/Radarr API keys, profile selections)
  # gets added in a follow-up after first boot.
  services.recyclarr.enable = true;

  users.users.jellyfin.extraGroups = [ "media" "render" "video" ];
  users.users.sonarr.extraGroups   = [ "media" ];
  users.users.radarr.extraGroups   = [ "media" ];
  users.users.bazarr.extraGroups   = [ "media" ];
  users.users.sabnzbd.extraGroups  = [ "media" ];

  age.secrets.tailscale-authkey.file = ../../secrets/tailscale-authkey.age;
  age.secrets.restic-password.file   = ../../secrets/restic-password.age;
  age.secrets.restic-env.file        = ../../secrets/restic-env.age;

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale-authkey.path;
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "jellyfin.seeley.me".extraConfig = "reverse_proxy localhost:8096";
      "request.seeley.me".extraConfig  = "reverse_proxy localhost:5055";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Restic repo TBD. Hetzner Storage Box format:
  #   sftp:u<id>@u<id>.your-storagebox.de:/server-media
  services.restic.backups.state = {
    paths = [
      "/var/lib/sonarr"
      "/var/lib/radarr"
      "/var/lib/prowlarr"
      "/var/lib/bazarr"
      "/var/lib/jellyseerr"
      "/var/lib/sabnzbd"
      "/var/lib/jellyfin"
    ];
    passwordFile    = config.age.secrets.restic-password.path;
    environmentFile = config.age.secrets.restic-env.path;
    repository      = "REPLACE_ME_RESTIC_REPO";
    timerConfig.OnCalendar = "daily";
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
  };
}
