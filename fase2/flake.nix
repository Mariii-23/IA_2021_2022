{
  description = "Trabalho IA";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShell = pkgs.mkShell {
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.swiProlog ];
        nativeBuildInputs = [ pkgs.bashInteractive ];
        buildInputs = with pkgs; [
          swiProlog
          (python3.withPackages (ps: with ps; [
            termcolor
            (ps.callPackage ({ pkgs, buildPythonPackage, lib, fetchPypi, python3Packages }:
              buildPythonPackage rec {
                pname = "pyswip";
                version = "0.2.10";

                propagatedBuildInputs = [ pkgs.swiProlog ];

                buildInputs = with python3Packages; [ pkgs.swiProlog pytest pytest-cov ];

                LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.swiProlog ];

                src = fetchPypi {
                  inherit pname version;
                  sha256 = "sha256-dphYTd9z0FHSLV/tcoueibtESp04TUjJ9eb9cGC7258=";
                };
              }) {})
          ]))
        ];
      };
    });
}
