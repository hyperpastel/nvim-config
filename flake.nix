{
  description = "A Nix flake for hyperpastel's Neovim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:

    flake-utils.lib.eachDefaultSystem (
      system:
      let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            lua-language-server
          ];

          shellHook = ''
            echo Entered neovim config development shell
          '';
        };
      }
    );
}
