{ lib, pkgs, config, stdenv, gcc, buildFHSUserEnvBubblewrap, mkDerivationFromStdenv, namePrefix, basePkgs }:

let
  # N.B. Keep in sync with default arg for stdenv/generic.
  defaultMkDerivationFromStdenv = mkDerivationFromStdenv { inherit lib config; };

  # Low level function to help with overriding `mkDerivationFromStdenv`. One
  # gives it the old stdenv arguments and a "continuation" function, and
  # underneath the final stdenv argument it yields to the continuation to do
  # whatever it wants with old `mkDerivation` (old `mkDerivationFromStdenv`
  # applied to the *new, final* stdenv) provided for convenience.
  withOldMkDerivation = stdenvSuperArgs: k: stdenvSelf: let
    mkDerivationFromStdenv-super = stdenvSuperArgs.mkDerivationFromStdenv or defaultMkDerivationFromStdenv;
    mkDerivationSuper = mkDerivationFromStdenv-super stdenvSelf;
  in
    k stdenvSelf mkDerivationSuper;

  # Wrap the original `mkDerivation` providing extra args to it.
  extendMkDerivationArgs = old: f: withOldMkDerivation old (_: mkDerivationSuper: args:
    mkDerivationSuper (args // f args));

  # Wrap make to be used in FHS
  runMake = pkgs.writeShellScriptBin "run-make" ''
    exec /usr/bin/make "$@"
  '';
in
stdenv.override (old: {
  allowedRequisites = (old.allowedRequisites or []) ++ [ runMake ];
  preHook = ''
    make() {
        $runEnv ${runMake}/bin/run-make "$@"
    }
    ${old.preHook}
  '';
  mkDerivationFromStdenv = extendMkDerivationArgs old (args: let
      envName = "${args.pname}-env-${args.version}";
      env = buildFHSUserEnvBubblewrap {
        name = envName;
        targetPkgs = pkgs: (basePkgs pkgs) ++
          [ runMake gcc ] ++
          # direct dependencies
          (args.propagateBuildInputs or []) ++
          (args.buildInputs or []) ++
          (args.nativeBuildInputs or []) ++
          # propagated dependencies
          (lib.lists.flatten (map (drv: drv.drvAttrs.propagatedBuildInputs ) (args.propagatedBuildInputs or []))) ++
          (lib.lists.flatten (map (drv: drv.drvAttrs.propagatedBuildInputs ) (args.buildInputs or []))) ++
          (lib.lists.flatten (map (drv: drv.drvAttrs.propagatedBuildInputs ) (args.nativeBuildInputs or [])));
      };
    in
    {
      pname = namePrefix + args.pname;
      strictDeps = true;
      dontPatchShebangs = true;
      dontAddPrefix = true;
      propagatedBuildInputs = (lib.lists.flatten (map (drv: drv.drvAttrs.propagatedBuildInputs ) (args.buildInputs or []))) ++
          (args.buildInputs or []);
      nativeBuildInputs = [ env pkgs.binutils ];
      runEnv = "${env}/bin/${envName}";
      STRIP = "strip";
      preConfigure = (args.preConfigure or "") + ''
        # set to empty if unset
        : ''${configureScript=}
        : ''${configureFlags=}

        if [[ -z "$configureScript" && -x ./configure ]]; then
            configureScript="./configure"
        fi

        if [[ ! -z "$configureScript" ]]; then
            configureScript="$runEnv $configureScript"
        fi

        configureFlags="''${prefixKey:---prefix=}/usr $configureFlags"
      '';
      preInstall = (args.preInstall or "") + ''
        installFlags="DESTDIR=$out $installFlags"
      '';
      postInstall = (args.postInstall or "") + ''
        cd $out
        mv usr/* .
        rm -rf usr
      '';
    }
  );
})
