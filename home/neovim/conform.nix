{ pkgs, ... }: {
  programs.neovim = {
    plugins = [
      pkgs.vimPlugins.conform-nvim
    ];

    initLua = builtins.readFile ./lua/conform.lua;
  };
}
