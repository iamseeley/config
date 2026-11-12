{ pkgs, inputs, ... }:
let
  # language servers and formatters used by home/neovim/lua/{lsp,conform}.lua
  editorPackages = with pkgs; [
    typescript-language-server
    rust-analyzer
    nixd
    pyright
    prettierd
    black
    rustfmt
    nixfmt
    zls
    vscode-langservers-extracted
  ];
in
{
  imports = [ ./ssh.nix ];

  programs.neovim.extraPackages = editorPackages;

  home.packages =
    editorPackages
    ++ (with pkgs; [
      gh
      yq
      httpie
      curl
      codex
      lnav
      doctl
      lazygit
      just
    ])
    ++ [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
