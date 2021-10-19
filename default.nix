{ pkgs ? import (fetchTarball "https://github.com/nixos/nixpkgs/archive/d68053da0ab2e890703f6760854fe9f1d050b801.tar.gz") {}
, buildCrystalPackage ? pkgs.crystal.buildCrystalPackage
}:
buildCrystalPackage rec {
    pname = "barion";
    version = "0.2";

	src = ./.;

	format = "crystal";
	crystalBinaries.${pname}.src = "prompt.cr";
}

