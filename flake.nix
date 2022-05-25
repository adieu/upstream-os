{
  description = "UpstreamOS Flake";

  inputs.nixpkgs.url = "nixpkgs/nixos-21.11";

  outputs = { self, nixpkgs }@inputs:
    let

      # System types to support.
      supportedSystems = [ "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });

    in

    {

      # A Nixpkgs overlay.
      overlay = final: prev: {
        # Custom gcc which set dynamic linker to /lib64/ld-linux-x86-64.so.2
        gccDefaultDynamicLinker = final.gcc9.cc.overrideAttrs (oldAttrs: {
          postPatch = ''
            configureScripts=$(find . -name configure)
            for configureScript in $configureScripts; do
              patchShebangs $configureScript
            done
          '';
        });
        upstreamos = final.recurseIntoAttrs (let callPackage = final.newScope final.upstreamos; in {
          stdenv = final.callPackage ./pkgs/stdenv {
            stdenv = final.stdenvNoCC;
            gcc = final.gccDefaultDynamicLinker;
            inherit (final.upstreamos) buildFHSUserEnvBubblewrap;
            mkDerivationFromStdenv = import "${nixpkgs}/pkgs/stdenv/generic/make-derivation.nix";
          };
          buildFHSUserEnvBubblewrap = final.callPackage ./pkgs/build-fhs-userenv-bubblewrap { };
          glibc = callPackage ./pkgs/glibc { inherit (final) bash; };
          ncurses = callPackage ./pkgs/ncurses { };
          readline = callPackage ./pkgs/readline { };
          bash = callPackage ./pkgs/bash { };
          libattr = callPackage ./pkgs/libattr { };
          libacl = callPackage ./pkgs/libacl { };
          libpcre = callPackage ./pkgs/libpcre { };
          libzstd = callPackage ./pkgs/libzstd { };
          libsepol = callPackage ./pkgs/libsepol { };
          libselinux = callPackage ./pkgs/libselinux { };
          libxcrypt = callPackage ./pkgs/libxcrypt { };
          libcap = callPackage ./pkgs/libcap { };
          libseccomp = callPackage ./pkgs/libseccomp { };
          coreutils = callPackage ./pkgs/coreutils { };
          util-linux = callPackage ./pkgs/util-linux { };
          kmod = callPackage ./pkgs/kmod { };
          systemd = callPackage ./pkgs/systemd { };
        });
      };

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system: nixpkgsFor.${system}.upstreamos);

    };
}
