{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "generate-test-accounts";
      runtimeInputs = with pkgs; [
        _1password-cli
        openssl
        coreutils
      ];
      text = builtins.readFile ./scripts/generate-test-accounts.sh;
    })
  ];
}
