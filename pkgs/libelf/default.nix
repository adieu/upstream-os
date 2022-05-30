{stdenv, fetchurl, glibc, bash}:

let
  version = "0.8.13";
  sha256 = "0vf7s9dwk2xkmhb79aigqm0x0yfbw1j0b9ksm51207qwr179n6jr";
in
  stdenv.mkDerivation rec {
    pname = "libelf";
    inherit version;
    src = fetchurl {
        url = "https://fossies.org/linux/misc/old/${pname}-${version}.tar.gz";
        inherit sha256;
    };
    patches = [
      ./preprocessor-warnings.patch
    ];
    enableParallelBuilding = true;
    buildInputs = [glibc];
    nativeBuildInputs = [bash];
    configureFlags = [
        "--disable-shared"
        "--enable-static"
    ];
    preInstall = ''
      installFlagsArray+=("instroot=$out")
    '';
  }


