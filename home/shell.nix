let theme = import ./theme.nix; in
{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    shellAliases = {
      ls  = "eza";
      ll  = "eza -la";
      la  = "eza -a";
      lt  = "eza --tree";
      cat = "bat";
      g   = "git";
      gs  = "git status";
      gd  = "git diff";
      gl  = "git log --oneline --graph --decorate";
      ga  = "git add";
      gc  = "git commit";
      gp  = "git push";
      v   = "nvim";
      rebuild =
        if pkgs.stdenv.isDarwin
        then "sudo darwin-rebuild switch --flake ~/config"
        else "sudo nixos-rebuild switch --flake ~/config";
    };
    interactiveShellInit = ''
      fish_add_path --prepend /run/current-system/sw/bin
      fish_add_path --prepend /opt/homebrew/bin
      set fish_greeting

      set fish_color_normal ${theme.fg}
      set fish_color_command ${theme.fg-bright} --bold
      set fish_color_param ${theme.ansi.cyan}
      set fish_color_error ${theme.ansi.red} --bold
      set fish_color_quote ${theme.green}
      set fish_color_comment ${theme.fg-dim}
      set fish_color_search_match --background=${theme.ansi.blue}
      set fish_color_operator ${theme.orange}
      set fish_color_escape ${theme.yellow}
      set fish_color_autosuggestion ${theme.fg-dim}
    '';
    plugins = [
      {
        name = "hydro";
        src = pkgs.fishPlugins.hydro.src;
      }
    ];
  };

  programs.bat = {
    enable = true;
    config.theme = "base16";
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [ "--height 40%" "--layout=reverse" "--border" ];
    colors = {
      fg      = theme.fg;
      bg      = theme.bg;
      hl      = theme.green;
      "fg+"   = theme.fg-bright;
      "bg+"   = theme.bg-light;
      "hl+"   = theme.green;
      info    = theme.blue-gray;
      prompt  = theme.green;
      pointer = theme.orange;
      marker  = theme.orange;
      spinner = theme.blue-gray;
      header  = theme.blue-gray;
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
