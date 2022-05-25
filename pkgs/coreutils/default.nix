{stdenv, fetchurl, libattr, libacl, libcap, libselinux, libxcrypt, perl, bash}:

let
  version = "9.0";
  sha256 = "sha256-zjCs30pBvFuzDdlV6eqnX6IWtOPesIiJ7TJDPHs7l84=";
in
  stdenv.mkDerivation {
    pname = "coreutils";
    inherit version;
    src = fetchurl {
        url = "https://ftp.gnu.org/gnu/coreutils/coreutils-${version}.tar.xz";
        inherit sha256;
    };
    enableParallelBuilding = true;
    buildInputs = [libattr libacl libcap libselinux libxcrypt];
    nativeBuildInputs = [perl bash];
    configureFlags = [
        "--disable-acl"
        "--disable-rpath"
        "--enable-single-binary=symlinks"
        "--enable-no-install-program=kill,stdbuf,uptime"
        "--with-selinux"
        "--without-gmp"
        "--without-openssl"
    ];

  }


