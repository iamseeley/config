{ inputs, pkgs, ... }: {
  imports = [
    ../../modules/darwin/defaults.nix
    ../../modules/darwin/yabai.nix
  ];

  networking.hostName = "work-mac";
  system.stateVersion = 5;
  system.primaryUser = "tseeley";
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  users.users.tseeley.home = "/Users/tseeley";

  home-manager.users.tseeley.imports = [
    ../../home/dev.nix
    ../../home/alacritty.nix
    ../../home/ghostty.nix
    ../../home/tmux.nix
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    casks = [
      "1password"
      "1password-cli"
      "alt-tab"
      "anki"
      "balenaetcher"
      "cursor"
      "docker"
      "firefox"
      "flux"
      "font-jetbrains-mono-nerd-font"
      "google-chrome"
      "google-chrome@canary"
      "hammerspoon"
      "istat-menus"
      "kap"
      "keycastr"
      "logitune"
      "mochi"
      "mullvad-vpn"
      "ollama"
      "screen-studio"
      "signal"
      "spotify"
      "syncthing"
      "tailscale"
      "thunderbird"
      "visual-studio-code"
      "void"
      "windsurf"
      "zed"
      "zoom"
    ];
  };
}
