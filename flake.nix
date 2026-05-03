{
  description = "tseeley's system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      disko,
      agenix,
      ...
    }@inputs:
    let
      mkDarwinSystem =
        hostname:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/${hostname}
            home-manager.darwinModules.home-manager
            agenix.darwinModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.users.tseeley = import ./home;
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };

      mkNixosSystem =
        hostname: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/${hostname}
            home-manager.nixosModules.home-manager
            agenix.nixosModules.default
            disko.nixosModules.disko
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.users.tseeley = import ./home;
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-linux" ];
    in
    {
      darwinConfigurations = {
        "work-mac" = mkDarwinSystem "work-mac";
      };

      nixosConfigurations = {
        "personal-laptop" = mkNixosSystem "personal-laptop" "x86_64-linux";
        "server-mail" = mkNixosSystem "server-mail" "x86_64-linux";
        "server-services" = mkNixosSystem "server-services" "x86_64-linux";
        "server-media" = mkNixosSystem "server-media" "x86_64-linux";
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
