{ pkgs, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      vimwiki
    ];

    initLua = builtins.readFile ./lua/daily-notes.lua;
  };
}
