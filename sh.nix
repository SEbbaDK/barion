{ pkgs ? import <nixpkgs> {}
, mkDerivation ? pkgs.stdenv.mkDerivation
, bash ? pkgs.bash
, pcre ? pkgs.pcre
, git ? pkgs.git
}:
mkDerivation rec {
    pname = "sebbaprompt";
    version = "0.1";

    src = ./prompt.sh;

    nativeBuildInputs = [
        bash
        pcre
        git
    ];

	dontUnpack = true;
	dontBuild = true;

	installPhase = ''
		mkdir -p $out/bin
		cp $src prompt.sh
    	substituteInPlace prompt.sh \
    		--replace pcregrep ${pcre}/bin/pcregrep \
			--replace git ${git}/bin/git
		cp prompt.sh $out/bin/${pname}
	'';
}

