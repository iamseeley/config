{ ... }:
{
  # imported by every machine, NixOS and nix-darwin alike
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # nixpkgs comes from the flake inputs, so legacy channels aren't used
  nix.channel.enable = false;

  # schedules are platform-specific: modules/nixos/server.nix, modules/darwin/defaults.nix
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;
}
