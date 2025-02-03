{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    gomod2nix,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [gomod2nix.overlays.default];
        };
        goEnv = pkgs.mkGoEnv {
          pwd = ./.;
        };
      in {
        packages.default = pkgs.buildGoApplication {
          pname = "myapp";
          version = "0.1";
          pwd = ./.;
          src = ./.;
          modules = ./gomod2nix.toml;
        };
        devShell = with pkgs;
          mkShell {
            packages = [
              goEnv
            ];
          };
      }
    );
}
