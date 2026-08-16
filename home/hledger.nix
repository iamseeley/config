{ pkgs, ... }:

{
  home.packages = with pkgs; [
    hledger
    hledger-ui
  ];

  xdg.configFile."hledger/hledger.conf".text = ''
    LEDGER_FILE=~/wiki/finances/ledger.journal
    theme=dark
  '';
}
