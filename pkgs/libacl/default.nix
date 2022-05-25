{stdenv, fetchurl, libattr}:

let
  version = "2.2.53";
  sha256 = "sha256-Br6YZcb0GNhR/0SU4SQGVoNTuJH/4fWWs0aTw4evJsc=";
in
  stdenv.mkDerivation {
    pname = "libacl";
    inherit version;
    src = fetchurl {
        url = "https://download-mirror.savannah.gnu.org/releases/acl/acl-${version}.tar.gz";
        inherit sha256;
    };
    enableParallelBuilding = true;
    buildInputs = [libattr];
    C_INCLUDE_PATH = "/usr/include";
    configureFlags = [
        "--disable-nls"
        "--disable-rpath"
    ];

  }


