{ pkgs, inputs, ... }:
{
  home.packages =
    (with pkgs; [
      gh
      jq
      yq
      httpie
      htop
      curl
      codex
      lnav
      doctl
      ripgrep
      lazygit
      ncdu
    ])
    ++ [
      inputs.agenix.packages.${pkgs.system}.default
    ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
