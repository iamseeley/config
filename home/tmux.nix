let theme = import ./theme.nix; in
{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    terminal = "tmux-256color";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
    ];
    extraConfig = ''
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      bind -r h resize-pane -L 5
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5

      bind c new-window -c "#{pane_current_path}"

      set -g renumber-windows on
      set -ga terminal-overrides ",*256col*:Tc"

      set -g status-style "bg=${theme.status-bg},fg=${theme.status-fg}"
      set -g pane-border-style "fg=${theme.border}"
      set -g pane-active-border-style "fg=${theme.green}"
      set -g message-style "bg=${theme.bg-light},fg=${theme.fg}"
      set -g window-status-current-style "fg=${theme.green},bold"
      set -g window-status-style "fg=${theme.fg-dim}"
    '';
  };
}
