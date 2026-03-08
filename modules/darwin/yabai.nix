{ config, pkgs, ... }: {
  services.yabai = {
    enable = true;
    config = {
      layout             = "bsp";
      window_gap         = 8;
      top_padding        = 8;
      bottom_padding     = 8;
      left_padding       = 8;
      right_padding      = 8;
      mouse_follows_focus = "off";
      focus_follows_mouse = "off";
      window_placement   = "second_child";
    };
    extraConfig = ''
      yabai -m rule --add app="System Preferences" manage=off
      yabai -m rule --add app="System Settings"    manage=off
      yabai -m rule --add app="Calculator"         manage=off
      yabai -m rule --add app="Archive Utility"    manage=off
    '';
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      # Focus window
      cmd - h : yabai -m window --focus west
      cmd - j : yabai -m window --focus south
      cmd - k : yabai -m window --focus north
      cmd - l : yabai -m window --focus east

      # Move window
      cmd + shift - h : yabai -m window --warp west
      cmd + shift - j : yabai -m window --warp south
      cmd + shift - k : yabai -m window --warp north
      cmd + shift - l : yabai -m window --warp east

      # Switch space
      cmd - 1 : yabai -m space --focus 1
      cmd - 2 : yabai -m space --focus 2
      cmd - 3 : yabai -m space --focus 3
      cmd - 4 : yabai -m space --focus 4
      cmd - 5 : yabai -m space --focus 5

      # Move window to space
      cmd + shift - 1 : yabai -m window --space 1
      cmd + shift - 2 : yabai -m window --space 2
      cmd + shift - 3 : yabai -m window --space 3
      cmd + shift - 4 : yabai -m window --space 4
      cmd + shift - 5 : yabai -m window --space 5

      # Toggle fullscreen
      cmd - f : yabai -m window --toggle zoom-fullscreen

      # Toggle float
      cmd - t : yabai -m window --toggle float

      # Rotate layout
      cmd - r : yabai -m space --rotate 90

      # Close window
      cmd - q : yabai -m window --close

      # Open terminal
      cmd - return : open -na Alacritty
    '';
  };
}
