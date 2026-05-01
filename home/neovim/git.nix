{ pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [ mini-nvim ];
    initLua = builtins.readFile ./lua/git.lua;
  };
}
