{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  imports = [
    ./neovim.nix
  ];

  # Minimal package set
  home.packages = with pkgs; [
    # Add other CLI tools here as needed
  ];
}
