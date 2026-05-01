{ pkgs, ... }:
{
  programs.neovim = {
    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.javascript
        p.typescript
        p.tsx
        p.rust
        p.zig
        p.nix
        p.python
        p.lua
        p.vim
        p.json
        p.markdown
        p.markdown_inline
        p.bash
        p.wgsl
      ]))
    ];

    initLua = builtins.readFile ./lua/treesitter.lua;
  };
}
