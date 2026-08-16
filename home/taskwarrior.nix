{ pkgs, ... }:

{
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
    colorTheme = "dark-blue-256";
    config = {
      default.command = "next";
    };
  };
}
