{stdenv, fetchurl, glibc}:
let
  version = "6.2";
  sha256 = "sha256-MDBuDHbg+fHw3ph88cgqXCHhzmVouSJ/faW3HL6obJ0=";
in
  stdenv.mkDerivation {
    inherit version;
    pname = "ncurses";
    buildInputs = [ glibc ];
    enableParallelBuilding = true;

    src = fetchurl {
        url = "https://invisible-mirror.net/archives/ncurses/ncurses-${version}.tar.gz";
        inherit sha256;
    };

    configureFlags = [
        "--disable-big-core"
        "--disable-rpath"
        "--disable-rpath-hack"
        "--disable-stripping"
        "--disable-wattr-macros"
    ];
    installTargets = "install.libs install.data install.includes";
  }
