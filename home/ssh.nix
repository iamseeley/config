{ ... }: {
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
      "mk2" = {
        user = "thomas";
        # Forward the Mac's ssh-agent so git on mk2 uses keys unlocked here
        # instead of prompting for mk2's local key passphrase.
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
    };
  };
}
