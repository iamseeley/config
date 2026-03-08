{ pkgs, ... }: {
  home.packages = with pkgs; [
    gh
    jq
    yq
    httpie
    htop
    curl
    docker
    claude-code
    codex
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
