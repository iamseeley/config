{ pkgs, inputs, ... }:
{
  home.packages = (with pkgs; [
    gh
    jq
    yq
    httpie
    htop
    curl
    claude-code
    codex
    lnav
    doctl
  ]) ++ [
    inputs.agenix.packages.${pkgs.system}.default
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
