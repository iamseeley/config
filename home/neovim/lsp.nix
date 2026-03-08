{ pkgs, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
    ];

    initLua = builtins.readFile ./lua/lsp.lua;
  };
}
