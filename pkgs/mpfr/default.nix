{stdenv, fetchurl, gmp, bash}:

let
  version = "4.1.0";
  sha256 = "sha256-DJij8XMv9spOppBVIHnanFl4ctMOluwoQU7iPJVVin8=";
in
  stdenv.mkDerivation rec {
    pname = "mpfr";
    inherit version;
    src = fetchurl {
        url = "mirror://gnu/mpfr/${pname}-${version}.tar.xz";
        inherit sha256;
    };
    enableParallelBuilding = true;
    C_INCLUDE_PATH = "/usr/include";
    buildInputs = [gmp];
    nativeBuildInputs = [bash];
    configureFlags = [
        "--disable-shared"
        "--enable-static"
    ];
  }


