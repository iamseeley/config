{ inputs, pkgs, ... }: {
  imports = [
    ./shell.nix
    ./git.nix
    ./ssh.nix
    ./neovim
  ];

  home.username = "tseeley";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
