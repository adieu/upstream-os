{stdenv, fetchurl, glibc, gperf}:

let
  version = "2.5.1";
  sha256 = "sha256-7jB+ODx3qnmVq8WtpUTVHJcjrjmXaKl2Z9TNs8OjDVU=";
in
  stdenv.mkDerivation {
    pname = "libseccomp";
    inherit version;
    src = fetchurl {
        url = "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz";
        inherit sha256;
    };
    enableParallelBuilding = true;
    buildInputs = [glibc];
    nativeBuildInputs = [gperf];
  }


