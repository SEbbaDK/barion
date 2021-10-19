{ pkgs ? import <nixpkgs> {}
}:
pkgs.crystal.buildCrystalPackage rec {
    pname = "barion";
    version = "0.2";

	src = ./.;

	format = "crystal";
	crystalBinaries.${pname}.src = "prompt.cr";
}

