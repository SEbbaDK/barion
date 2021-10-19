{ pkgs ? import <nixpkgs> {}
}:
pkgs.crystal.buildCrystalPackage rec {
    pname = "sebbaprompt";
    version = "0.1";

	src = ./.;

	format = "crystal";
	crystalBinaries.${pname}.src = "prompt.cr";
}

