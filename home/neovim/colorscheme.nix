{ pkgs, ... }: {
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimUtils.buildVimPlugin {
        name = "mustang-vim";
        src = pkgs.fetchFromGitHub {
          owner = "croaker";
          repo = "mustang-vim";
          rev = "master";
          sha256 = "sha256-x/DEX2XoaKdrWuGvfa21laJgHEgRw7xjnG1IAnJmlX4=";
        };
      };
      type = "lua";
      config = ''vim.cmd([[colorscheme mustang]])'';
    }
  ];
}
