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
      alt - h : yabai -m window --focus west
      alt - j : yabai -m window --focus south
      alt - k : yabai -m window --focus north
      alt - l : yabai -m window --focus east

      # Move window
      alt + shift - h : yabai -m window --warp west
      alt + shift - j : yabai -m window --warp south
      alt + shift - k : yabai -m window --warp north
      alt + shift - l : yabai -m window --warp east

      # Switch space
      alt - 1 : yabai -m space --focus 1
      alt - 2 : yabai -m space --focus 2
      alt - 3 : yabai -m space --focus 3
      alt - 4 : yabai -m space --focus 4
      alt - 5 : yabai -m space --focus 5

      # Move window to space
      alt + shift - 1 : yabai -m window --space 1
      alt + shift - 2 : yabai -m window --space 2
      alt + shift - 3 : yabai -m window --space 3
      alt + shift - 4 : yabai -m window --space 4
      alt + shift - 5 : yabai -m window --space 5

      # Toggle fullscreen
      alt - f : yabai -m window --toggle zoom-fullscreen

      # Toggle float
      alt - t : yabai -m window --toggle float

      # Rotate layout
      alt - r : yabai -m space --rotate 90

      # Close window
      alt - q : yabai -m window --close

      # Open terminal
      alt - return : open -na Alacritty
    '';
  };
}
