{ pkgs, ... }:
let
  jq = "${pkgs.jq}/bin/jq";

  statusline = pkgs.writeShellScript "claude-statusline" ''
    input=$(cat)
    get() { printf '%s' "$input" | ${jq} -r "$1 // empty"; }

    model=$(get '.model.display_name')
    dir=$(basename "$(get '.workspace.current_dir')")
    ctx=$(get '.context_window.used_percentage')
    cost=$(get '.cost.total_cost_usd')
    five=$(get '.rate_limits.five_hour.used_percentage')
    five_reset=$(get '.rate_limits.five_hour.resets_at')
    week=$(get '.rate_limits.seven_day.used_percentage')

    out="$model  $dir"
    [ -n "$ctx" ] && out="$out  ctx:$(printf '%.0f' "$ctx")%"
    if [ -n "$five" ]; then
      out="$out  5h:$(printf '%.0f' "$five")%"
      [ -n "$five_reset" ] && out="$out (resets $(date -r "$five_reset" +%H:%M))"
    fi
    [ -n "$week" ] && out="$out  7d:$(printf '%.0f' "$week")%"
    [ -n "$cost" ] && out="$out  \$$(printf '%.2f' "$cost")"
    printf '%s' "$out"
  '';

  notify = pkgs.writeShellScript "claude-notify" ''
    input=$(cat)
    dir=$(basename "$(printf '%s' "$input" | ${jq} -r '.cwd // empty')")
    msg=$(printf '%s' "$input" | ${jq} -r '(.message // "Claude finished the turn") | gsub("\""; "'"'"'")')
    /usr/bin/osascript -e "display notification \"$msg\" with title \"Claude: $dir\" subtitle \"$1\" sound name \"Glass\""
  '';
in
{
  programs.claude-code = {
    enable = true;
    settings = {
      model = "opus";
      effortLevel = "high";
      theme = "dark";
      attribution = {
        commit = "";
        pr = "";
      };
      includeCoAuthoredBy = false;
      env.DISABLE_AUTOUPDATER = "1";
      enabledPlugins = {
        "rust-analyzer-lsp@claude-plugins-official" = true;
        "typescript-lsp@claude-plugins-official" = true;
        "clangd-lsp@claude-plugins-official" = true;
        "pyright-lsp@claude-plugins-official" = true;
      };
      permissions = {
        allow = [
          "Bash(cargo test:*)"
          "Bash(nix build:*)"
          "Bash(git diff:*)"
        ];
        deny = [ "Bash(git push --force:*)" ];
      };

      statusLine = {
        type = "command";
        command = "${statusline}";
      };

      hooks = {
        Notification = [
          {
            hooks = [
              {
                type = "command";
                command = "${notify} 'Waiting on you'";
              }
            ];
          }
        ];
        Stop = [
          {
            hooks = [
              {
                type = "command";
                command = "${notify} 'Done'";
              }
            ];
          }
        ];
      };
    };
  };
}
