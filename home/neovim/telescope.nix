{ pkgs, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      telescope-nvim
    ];

    initLua = builtins.readFile ./lua/telescope.lua;
  };
}
