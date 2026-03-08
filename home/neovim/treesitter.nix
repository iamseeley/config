{ pkgs, ... }: {
  programs.neovim = {
    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
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
    ];

    initLua = builtins.readFile ./lua/treesitter.lua;
  };
}
