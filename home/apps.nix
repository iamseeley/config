let
  theme = import ./theme.nix;
in
{ pkgs, inputs, ... }:
let
  addons = inputs.firefox-addons.packages.${pkgs.system};
in
{
  home.packages = with pkgs; [
    _1password-gui
    _1password-cli
    anki
    google-chrome
    mullvad-vpn
    signal-desktop
    spotify
    thunderbird
    vscode
    zed-editor
    vlc
    gimp
    zoom-us
    obs-studio
    (nerdfonts.override { fonts = [ "Lilex" ]; })
  ];

  fonts.fontconfig.enable = true;

  programs.firefox = {
    enable = true;
    profiles.tseeley = {
      extensions.packages = with addons; [
        ublock-origin
        onepassword-password-manager
        bitwarden
        darkreader
        kagi-search
      ];

      bookmarks = [
        {
          name = "Toolbar";
          toolbar = true;
          bookmarks = [
            {
              name = "GitHub";
              url = "https://github.com";
            }
            {
              name = "Kagi";
              url = "https://kagi.com";
            }
            {
              name = "NixOS";
              url = "https://search.nixos.org/packages";
            }
            {
              name = "HN";
              url = "https://news.ycombinator.com";
            }
          ];
        }
        {
          name = ".me";
          bookmarks = [
            {
              name = "Mail Admin";
              url = "https://mail.seeley.me:443";
            }
            {
              name = "CMS";
              url = "https://cms.seeley.me";
            }
            {
              name = "Analytics";
              url = "https://stats.seeley.me";
            }
            {
              name = "Feeds";
              url = "https://feeds.seeley.me";
            }
            {
              name = "Bookmarks";
              url = "https://bookmarks.seeley.me";
            }
          ];
        }
      ];

      userChrome = ''
        :root {
          --toolbar-bgcolor: ${theme.bg} !important;
          --toolbar-color: ${theme.fg} !important;
          --tab-selected-bgcolor: ${theme.bg-light} !important;
          --tab-selected-textcolor: ${theme.fg-bright} !important;
          --lwt-accent-color: ${theme.bg} !important;
          --lwt-text-color: ${theme.fg} !important;
          --urlbar-box-bgcolor: ${theme.bg-light} !important;
          --urlbar-box-text-color: ${theme.fg} !important;
          --sidebar-background-color: ${theme.bg} !important;
          --sidebar-text-color: ${theme.fg} !important;
        }

        #TabsToolbar { background-color: ${theme.bg} !important; }
        .tab-background:not([selected]) { background-color: ${theme.bg} !important; }
        .tab-background[selected] { background-color: ${theme.bg-light} !important; }
        .tab-text { color: ${theme.fg} !important; }
        .tab-text[selected] { color: ${theme.fg-bright} !important; }
      '';

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.startup.homepage" = "about:blank";
        "browser.search.defaultenginename" = "Kagi";
        "privacy.trackingprotection.enabled" = true;
        "ui.systemUsesDarkTheme" = 1;
      };
    };
  };
}
