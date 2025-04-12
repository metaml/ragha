{
  description = "autoprompt: llm augmented memory";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pname = "autoprompt";
        version = "0.1.0";
        pkgs = nixpkgs.legacyPackages.${system};
        haskpkgs = pkgs.haskell.packages.ghc;
        llvmpkgs = pkgs.llvmPackages_latest;
        autoprompt  = pkgs.runCommand pname
                                      { preferLocalBuild = true; buildInputs = [ pname ]; }
                                      '''';
        nixConfig.sandbox = "relaxed";
      in {
        packages.default = with import nixpkgs { inherit system; };
          stdenv.mkDerivation {
            __noChroot = true;
            name = "${pname}";
            src = self;
            version = "${version}";

            buildInputs = with pkgs; [
              cacert
              git
              haskpkgs.cabal-install
              haskpkgs.ghc
              zlib
            ];

            buildPhase = ''
              export HOME=$TMP
              export CABAL_DIR=$TMP
              cabal update --verbose
              mkdir -p $out/bin
            '';

            installPhase = ''
              export HOME=$TMP
              export CABAL_DIR=$HOME
              cabal install --install-method=copy --overwrite-policy=always --installdir=$out/bin exe:autoprompt
            '';
          };
        defaultPackage = self.packages.${system}.default;

        packages.docker = pkgs.dockerTools.buildImage {
          name = "${pname}";
          tag = "latest";
          created = "now";

          copyToRoot = pkgs.buildEnv {
            name = "${pname}";
            paths = with pkgs; [ cacert
                                 self.defaultPackage.${system}
                               ];
            pathsToLink = [ "/bin/${pname}" ];
          };

          config = {
            WorkingDir = "/";
            Env = [
              "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
              "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
              "SYSTEM_CERTIFICATE_PATH=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
            ];
            EntryPoint = [ "/bin/${pname}" ];
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            libffi
            zlib
          ];
          # nativeBuildInputs = with pkgs; [
          #   cacert
          #   coreutils
          #   findutils
          #   fswatch
          #   ghcid
          #   git
          #   gnugrep
          #   gnumake
          #   gnused
          #   haskpkgs.cabal-install
          #   haskpkgs.cpphs
          #   haskpkgs.ghc
          #   haskpkgs.hlint
          #   llvmpkgs.clangWithLibcAndBasicRtAndLibcxx
          #   postgresql
          #   sourceHighlight
          #   watchexec
          # ];
          shellHook = ''
            export SHELL=$BASH
            export LANG=en_US.UTF-8
            export PS1="ragha|$PS1"
            export VERSION=$(git rev-parse HEAD)
          '';

        };
        devShell = self.devShells.${system}.default;
      }
    );
}
