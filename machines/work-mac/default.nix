{ pkgs, ... }:
{
  imports = [
    ../../modules/darwin/defaults.nix
    ../../modules/darwin/yabai.nix
    ../../modules/darwin/speedlog.nix
  ];
  networking.hostName = "work-mac";
  # set when nix-darwin was first installed; never bump it
  system.stateVersion = 5;
  system.primaryUser = "tseeley";

  nix.settings.trusted-users = [ "tseeley" ];
  nixpkgs.config.allowUnfree = true;
  programs.fish.enable = true;

  users.users.tseeley = {
    home = "/Users/tseeley";
    shell = pkgs.fish;
  };
  home-manager.users.tseeley.imports = [
    ../../home/dev.nix
    ../../home/desktop.nix
  ];
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      # removes anything installed with brew that isn't listed here (keeps app data)
      cleanup = "uninstall";
    };
    casks = [
      "1password"
      "1password-cli"
      "alacritty"
      "alt-tab"
      "anki"
      "cursor"
      "docker-desktop"
      "firefox"
      "flux-app"
      "font-lilex-nerd-font"
      "google-chrome"
      "google-chrome@canary"
      "hammerspoon"
      "istat-menus"
      "kap"
      "keycastr"
      "logitune"
      "mullvad-vpn"
      "ollama-app"
      "screen-studio"
      "signal"
      "spotify"
      "syncthing-app"
      "tailscale-app"
      "thunderbird"
      "zed"
      "zoom"
      "sublime-text"
      "wacom-tablet"
    ];
    brews = [
      "binaryen"
      "brotli"
      "openssl@3"
      "pkgconf"
      "terminal-notifier"
      "trivy"
    ];
  };
}
