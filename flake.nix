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

    # not following nixpkgs: the site pins the zola version it was written for
    tseeley-site.url = "github:iamseeley/tseeley.com";

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
            ./machines/${hostname}
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
            ./machines/${hostname}
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
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "x86_64-linux"
      ];
    in
    {
      darwinConfigurations = {
        "work-mac" = mkDarwinSystem "work-mac";
      };

      nixosConfigurations = {
        "mail" = mkNixosSystem "mail" "x86_64-linux";
        "apps" = mkNixosSystem "apps" "x86_64-linux";
        "thinky" = mkNixosSystem "thinky" "x86_64-linux";
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
