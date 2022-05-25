{fetchurl, stdenv, readline }:

let
  version = "5.0";
  sha256 = "sha256-tKgPKsZhcLKRPvv7nyWU8fdsexr9EfeZ4iA11jB3+00=";
in
  stdenv.mkDerivation {
    inherit version;
    pname = "bash";
    buildInputs = [ readline ];
    #nativeBuildInputs = [ oribash ];
    enableParallelBuilding = true;

    src = fetchurl {
        url = "mirror://gnu/bash/bash-${version}.tar.gz";
        inherit sha256;
    };

    configureFlags = [
        "--with-bash-malloc=no"
        "--with-installed-readline"
    ];
    buildFlagsArray = ( "CPPFLAGS='-D_GNU_SOURCE -DRECYCLES_PIDS'" );

    postInstall = ''
      ln -s bash $out/usr/bin/sh
      #rm -f $out/usr/lib/bash/Makefile.inc
    '';
  }
