{ ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "server-mail" = {
        hostname = "mail.seeley.me";
        user = "root";
      };
      "server-services" = {
        hostname = "services.seeley.me";
        user = "root";
      };
    };
  };
}
