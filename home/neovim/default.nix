{ pkgs, lib, ... }:

let
  neovimPackages = with pkgs; [
    typescript-language-server
    rust-analyzer
    nixd
    pyright
    ripgrep
    fd
    prettierd
    black
    rustfmt
    nixfmt
    zls
  ];
in
{
  imports = [
    ./colorscheme.nix
    ./treesitter.nix
    ./lsp.nix
    ./completion.nix
    ./telescope.nix
    ./conform.nix
    ./oil.nix
    ./daily-notes.nix
    ./git.nix
    ./markdown.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = neovimPackages;

    initLua = lib.mkBefore ''
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.clipboard = "unnamedplus"
    '';
  };

  home.packages = neovimPackages;
}
