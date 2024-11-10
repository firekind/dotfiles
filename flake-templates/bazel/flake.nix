{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem(system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShell = with pkgs; mkShell {
          packages = 
            let 
              bazel-bin = writeShellScriptBin "bazel" "exec ${bazelisk}/bin/bazelisk $@";
            in [
              bazel-bin
              bazel-buildtools
            ];
        };
      }
    );
}