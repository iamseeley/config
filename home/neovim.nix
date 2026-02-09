{ config, pkgs, ... }:

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
  ];
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      (pkgs.vimUtils.buildVimPlugin {
        name = "mustang-vim";
        src = pkgs.fetchFromGitHub {
          owner = "croaker";
          repo = "mustang-vim";
          rev = "master";
          sha256 = "sha256-x/DEX2XoaKdrWuGvfa21laJgHEgRw7xjnG1IAnJmlX4=";
        };
      })

      (nvim-treesitter.withPlugins (p: [
        p.javascript
        p.typescript
        p.tsx
        p.rust
        p.nix
        p.python
        p.lua
        p.vim
        p.json
        p.markdown
        p.bash
      ]))

      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      telescope-nvim
      plenary-nvim
      vimwiki
      oil-nvim
      conform-nvim
    ];

    extraPackages = neovimPackages;

    initLua = builtins.readFile ./neovim/init.lua;
  };

  xdg.configFile."nvim/lua" = {
    source = ./neovim/lua;
    recursive = true;
  };

  home.packages = neovimPackages;
}
