{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    hledger
    hledger-ui
  ];

  home.sessionVariables.LEDGER_FILE = "${config.home.homeDirectory}/wiki/finances/ledger.journal";

  xdg.configFile."hledger/hledger.conf".text = ''
    [ui]
    --theme=terminal.dark
  '';
}
