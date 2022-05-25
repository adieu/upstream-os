{stdenv, fetchurl, glibc}:

let
  version = "2.5.1";
  sha256 = "sha256-20SKYm+TE6GpcNY2dnMWqNoyrt5wUYuAUPoN55R63DI=";
in
  stdenv.mkDerivation {
    pname = "libattr";
    inherit version;
    src = fetchurl {
        url = "https://download-mirror.savannah.gnu.org/releases/attr/attr-${version}.tar.xz";
        inherit sha256;
    };
    enableParallelBuilding = true;
    buildInputs = [glibc];

  }

