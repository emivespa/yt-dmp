{
  description = "A Nix-flake-based Node.js development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }:

    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      packages = [
        gnumake
        python3
        sam
      ]
    in
    {
      devShells.default = pkgs.mkShell {
        packages = packages;

        shellHook = ''
          echo entering dev shell
        '';
      };
    });
}

