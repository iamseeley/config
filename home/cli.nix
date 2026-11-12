{ pkgs, ... }:
{
  imports = [
    ./shell.nix
    ./git.nix
    ./neovim
    ./tmux.nix
  ];

  home.username = "tseeley";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    htop
    ncdu
  ];

  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;
}
