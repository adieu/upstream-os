{stdenv, fetchurl, ncurses}:

let
  version = "8.1";
  sha256 = "sha256-+M607hMeMjIiahf1GxZK/EbNC55s7zRL6Hxlliy4KwI=";
in
  stdenv.mkDerivation {
    pname = "readline";
    inherit version;
    src = fetchurl {
        url = "mirror://gnu/readline/readline-${version}.tar.gz";
        inherit sha256;
    };
    enableParallelBuilding = true;
    buildInputs = [ncurses];

    configureFlags = [
        "--with-curses"
        "--disable-install-examples"
    ];
  }
