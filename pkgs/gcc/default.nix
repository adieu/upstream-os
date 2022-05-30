{stdenv, fetchurl, gmp, mpfr, libmpc, libelf, bash, file, perl, gnum4, gettext, linuxHeaders}:

let
  majorVersion = "9";
  version = "${majorVersion}.3.0";
  sha256 = "sha256-ceGXhnYR9gVKoRGbE6DAq6wSg0dl/i2B81rFf4T3QtE=";
in
  stdenv.mkDerivation {
    pname = "gcc";
    inherit version;
    src = fetchurl {
        url = "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.xz";
        inherit sha256;
    };
    patches = [ ./libsanitizer-no-cyclades-9.patch ];
    NIX_NO_SELF_RPATH = true;
    enableParallelBuilding = true;
    buildInputs = [gmp mpfr libmpc libelf];
    nativeBuildInputs = [bash file perl gnum4 gettext linuxHeaders];
    C_INCLUDE_PATH = "/usr/include";
    CPLUS_INCLUDE_PATH = "/usr/include";
    LIBRARY_PATH = "/usr/lib";
    CPP = "cpp";
    configureFlags = [
        "--enable-languages=c,c++"
        "--disable-multilib"
        "--disable-bootstrap"
        "--enable-lto"
        "--with-gmp-include=/usr/include"
        "--with-gmp-lib=/usr/lib"
        "--with-mpfr-include=/usr/include"
        "--with-mpfr-lib=/usr/lib"
        "--with-mpc=/usr"
    ];
    preConfigure = ''
      mkdir ../build
      cd ../build
      configureScript="`pwd`/../$sourceRoot/configure"
    '';
    postFixup = ''
      rm -rf $out/libexec/gcc/*/*/install-tools
      rm -rf $out/lib/gcc/*/*/install-tools
      rm -rfv $out/lib/gcc/*/*/include-fixed/{root,linux,bits}
    '';

  }


