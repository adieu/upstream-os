{stdenv, fetchurl, glibc, bash, m4}:

let
  version = "6.2.1";
  sha256 = "sha256-6ukya+tBWMOG45o1aBgDG9KPMSTPkV+MWx3Ex6NrTXw=";
in
  stdenv.mkDerivation rec {
    pname = "gmp";
    inherit version;
    src = fetchurl {
        url = "mirror://gnu/gmp/${pname}-${version}.tar.bz2";
        inherit sha256;
    };
    enableParallelBuilding = true;
    buildInputs = [glibc];
    nativeBuildInputs = [bash m4];
    configureFlags = [
        "--with-pic"
        "--disable-shared"
        "--enable-static"
    ];
  }


