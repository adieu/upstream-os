{stdenv, fetchurl, gmp, mpfr}:

let
  version = "1.2.1";
  sha256 = "sha256-F1A9LDld/PEGtiLcFCaDwRmUMdCVNnxqrLpu7DA0BFk=";
in
  stdenv.mkDerivation rec {
    pname = "libmpc";
    inherit version;
    src = fetchurl {
        url = "mirror://gnu/mpc/mpc-${version}.tar.gz";
        inherit sha256;
    };
    enableParallelBuilding = true;
    C_INCLUDE_PATH = "/usr/include";
    buildInputs = [gmp mpfr];
    configureFlags = [
        "--disable-shared"
        "--enable-static"
    ];
  }


