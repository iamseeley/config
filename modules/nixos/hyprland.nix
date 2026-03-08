{ config, pkgs, ... }: {
  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.systemPackages = with pkgs; [
    waybar
    wofi
    mako
    grim
    slurp
    wl-clipboard
    brightnessctl
    pamixer
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.hyprland}/bin/Hyprland";
      user    = "tseeley";
    };
  };

  home-manager.users.tseeley.wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

      general = {
        gaps_in  = 4;
        gaps_out = 8;
        border_size = 2;
        layout = "dwindle";
      };

      dwindle = {
        pseudotile = false;
        preserve_split = true;
      };

      input = {
        follow_mouse = 0;
        kb_layout = "us";
      };

      bind = [
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"

        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"

        "$mod, F, fullscreen, 0"
        "$mod, T, togglefloating"
        "$mod, Q, killactive"
        "$mod, SPACE, exec, wofi --show drun"
        "$mod, Return, exec, alacritty"

        ''$mod SHIFT, S, exec, grim -g "$(slurp)" - | wl-copy''
      ];
    };
  };
}
