let theme = import ./theme.nix; in
{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    settings = {
      font-family = "Lilex Nerd Font";
      font-size = 12;
      background = theme.bg;
      foreground = theme.fg;
      cursor-color = theme.cursor;
      selection-background = theme.bg-sel;
      selection-foreground = theme.cream;
      palette = [
        "0=${theme.ansi.black}"
        "1=${theme.ansi.red}"
        "2=${theme.ansi.green}"
        "3=${theme.ansi.yellow}"
        "4=${theme.ansi.blue}"
        "5=${theme.ansi.magenta}"
        "6=${theme.ansi.cyan}"
        "7=${theme.ansi.white}"
        "8=${theme.ansi.bright-black}"
        "9=${theme.ansi.bright-red}"
        "10=${theme.ansi.bright-green}"
        "11=${theme.ansi.bright-yellow}"
        "12=${theme.ansi.bright-blue}"
        "13=${theme.ansi.bright-magenta}"
        "14=${theme.ansi.bright-cyan}"
        "15=${theme.ansi.bright-white}"
      ];
      window-padding-x = 8;
      window-padding-y = 8;
      window-decoration = false;
      background-opacity = 0.95;
      copy-on-select = "clipboard";
    };
  };
}
