{ pkgs, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      nvim-cmp
    ];

    initLua = builtins.readFile ./lua/completion.lua;
  };
}
