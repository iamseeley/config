let theme = import ./theme.nix; in
{ ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = { x = 8; y = 8; };
        decorations = "None";
        opacity = 0.95;
      };
      font = {
        size = 12.0;
        normal.family = "Lilex Nerd Font";
        bold.style = "Bold";
        italic.style = "Italic";
      };
      colors = {
        primary = {
          background = theme.bg;
          foreground = theme.fg;
        };
        cursor = {
          cursor = theme.cursor;
          text   = theme.bg;
        };
        normal = {
          black   = theme.ansi.black;
          red     = theme.ansi.red;
          green   = theme.ansi.green;
          yellow  = theme.ansi.yellow;
          blue    = theme.ansi.blue;
          magenta = theme.ansi.magenta;
          cyan    = theme.ansi.cyan;
          white   = theme.ansi.white;
        };
        bright = {
          black   = theme.ansi.bright-black;
          red     = theme.ansi.bright-red;
          green   = theme.ansi.bright-green;
          yellow  = theme.ansi.bright-yellow;
          blue    = theme.ansi.bright-blue;
          magenta = theme.ansi.bright-magenta;
          cyan    = theme.ansi.bright-cyan;
          white   = theme.ansi.bright-white;
        };
        selection = {
          background = theme.bg-sel;
          text       = theme.cream;
        };
      };
      keyboard.bindings = [
        { key = "N"; mods = "Command"; action = "SpawnNewInstance"; }
      ];
    };
  };
}
