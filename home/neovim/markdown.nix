{ pkgs, ... }:
{
  programs.neovim = {
    plugins = [
      pkgs.vimPlugins.render-markdown-nvim
    ];
    initLua = builtins.readFile ./lua/markdown.lua;
  };
}
