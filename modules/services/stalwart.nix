{ config, pkgs, ... }: {
  services.stalwart-mail = {
    enable = true;
    settings = {
      server.hostname = "mail.seeley.me";
      server.listener = {
        smtp        = { bind = ["[::]:25"];   protocol = "smtp"; };
        submission  = { bind = ["[::]:587"];  protocol = "smtp"; };
        submissions = { bind = ["[::]:465"];  protocol = "smtp";
                        tls.implicit = true; };
        imap        = { bind = ["[::]:143"];  protocol = "imap"; };
        imaptls     = { bind = ["[::]:993"];  protocol = "imap";
                        tls.implicit = true; };
        pop3        = { bind = ["[::]:110"];  protocol = "pop3"; };
        pop3s       = { bind = ["[::]:995"];  protocol = "pop3";
                        tls.implicit = true; };
        sieve       = { bind = ["[::]:4190"]; protocol = "managesieve"; };
        http        = { bind = ["[::]:8080"]; protocol = "http"; };
        https       = { bind = ["[::]:443"];  protocol = "http";
                        tls.implicit = true; };
      };
      storage = {
        data = "rocksdb"; blob = "rocksdb";
        fts  = "rocksdb"; lookup = "rocksdb";
        directory = "internal";
      };
      store.rocksdb = {
        type        = "rocksdb";
        path        = "/var/lib/stalwart-mail/data";
        compression = "lz4";
      };
      directory.internal = { type = "internal"; store = "rocksdb"; };
      tracer.log = {
        type   = "log"; enable = true; level = "info";
        path   = "/var/log/stalwart-mail";
        prefix = "stalwart.log"; rotate = "daily"; ansi = false;
      };
    };
  };

  age.secrets.stalwart-admin.file = ../../secrets/stalwart-admin.age;
  systemd.services.stalwart-mail.serviceConfig.EnvironmentFile =
    config.age.secrets.stalwart-admin.path;
}
