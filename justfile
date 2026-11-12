default:
    @just --list

# Deploy a NixOS host: just deploy server-services [switch|dry-activate|boot]
deploy host action="switch":
    nix run nixpkgs#nixos-rebuild -- {{action}} --flake .#{{host}} --target-host {{host}} --build-host {{host}}

# Roll a host back to its previous generation
rollback host:
    nix run nixpkgs#nixos-rebuild -- switch --rollback --target-host {{host}}

# Check whether the repo matches what's running on a host
drift host:
    @test "$(nix eval --raw .#nixosConfigurations.{{host}}.config.system.build.toplevel.outPath)" = "$(ssh {{host}} readlink /run/current-system)" && echo "in sync" || echo "differs"

# Update all flake inputs
update:
    nix flake update

# Re-encrypt secrets after changing keys in secrets.nix
rekey:
    agenix -r

# Publish the latest tseeley.com commit
site:
    nix flake update tseeley-site
    just deploy server-services
