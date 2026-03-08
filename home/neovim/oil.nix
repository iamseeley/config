{ pkgs, ... }: {
  programs.neovim = {
    plugins = [
      pkgs.vimPlugins.oil-nvim
    ];

    initLua = builtins.readFile ./lua/oil.lua;
  };
}
