{ inputs, pkgs, ... }:
{
  imports = [
    ./shell.nix
    ./git.nix
  ];

  home.username = "tseeley";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;
}
