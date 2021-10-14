{ pkgs ? import <nixpkgs> {}
, mkShell ? pkgs.mkShell
}:
mkShell {
    name = "crystal-prompt-shell";
    buildInputs = with pkgs; [
        bash
        pcregrep
        git
    ];
}

