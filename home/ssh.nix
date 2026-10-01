{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        # Load keys into the agent on first use and cache passphrases in the
        # macOS Keychain so they survive reboots.
        addKeysToAgent = "yes";
        extraOptions = {
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
        hostname = "services.seeley.me";
        user = "root";
      };
      "thinky" = {
        hostname = "192.168.0.74";
        user = "root";
      };
    };
  };
}
