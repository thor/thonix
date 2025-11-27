{
  description = "System Flake for darwin hosts";

  inputs = {
    # the core packages
    # Pinned to c0780d221c27ea0c486794b2bc30b3a0b007b6ee for the time
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # the macOS experience
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    # sort out the formatting
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    # rust
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # homebrew and declarative taps
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    sikarugir = {
      url = "github:Sikarugir-App/homebrew-sikarugir";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      systems,
      treefmt-nix,
      fenix,
      nix-homebrew,
      ...
    }:
    let
      # Small tool to iterate over each systems
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

      commonModules = [
        ./personal
        nix-homebrew.darwinModules.nix-homebrew
      ];
      workModules = commonModules ++ [
        ./work
      ];
    in
    {
      # for `nix fmt`
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);

      # for `nix flake check`
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.check self;
      });

      # for `darwin-rebuild build --flake .#lincoln-golf`
      darwinConfigurations."lincoln-golf" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs self; };
        modules = workModules ++ [
          ./configurations/darwin/lincoln-golf.nix
        ];
      };

      # for `darwin-rebuild build --flake .#lincoln-hotel`
      darwinConfigurations."lincoln-hotel" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs self; };
        modules = workModules ++ [
          ./configurations/darwin/lincoln-hotel.nix
        ];
      };

      # for `darwin-rebuild build --flake .#lincoln-foxtrot`
      darwinConfigurations."lincoln-foxtrot" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs self; };
        modules = commonModules ++ [
          ./configurations/darwin/lincoln-foxtrot.nix
        ];
      };
    };
}
